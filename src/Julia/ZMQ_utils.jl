using JSON3, ImageCore

const PROTOC_V = UInt8(1)

function err_dict(;err::Bool=false, errcode::Int=0, source::String="", longdescr::String="no errors")
   if err
      # # default values on error
      if errcode == 0
         errcode = 5235805
      end
      if longdescr == ""
         longdescr = "Julia script error"
      end
   end

   return Dict(:status=>err, :code=>errcode, :source=>source, :longdescr=>longdescr)
end

Bytearr = Vector{UInt8} # byte array

function int2bytar(i::Int; i_type=UInt32)
   reinterpret(UInt8, [i_type(i)])
end

function bytar2int(b::Bytearr; i_type=UInt32)
   i=reinterpret(i_type, b)[1]
end

function puttogether(;
                      # bin_data::Bytearr=UInt8[],
                      y=Dict{Symbol, Any}(),
                      err=err_dict(),
                      opt_header::Bytearr=UInt8[],
                      shorterrcode::Int=0
                      )


   shorterrcode = UInt8(shorterrcode)
   y = Dict{Symbol, Any}(pairs(y)) # y can be Dict or named tuple

   @assert haskey(err, :status) & haskey(err, :code) & haskey(err, :source) & haskey(err, :longdescr)

   if haskey(y, :bin_data)
      bin_data = y[:bin_data]
   else
      bin_data=UInt8[]
   end

   push!(y, :errorinfo=>err)
   jsonstring = Bytearr(JSON3.write(y))

   o_h_lng = int2bytar(length(opt_header))
   bin_lng = int2bytar(length(bin_data))
   js_lng = int2bytar(length(jsonstring))

   r = vcat(shorterrcode, PROTOC_V, o_h_lng, bin_lng, opt_header, bin_data, jsonstring)

   return r
end

function parse_cmnd(b)
   c = b[1]
   prot_v = b[2]
   prot_OK = prot_v <= PROTOC_V
   if c == UInt8('p')
      command = :ping
   elseif c == UInt8('s')
      command = :stop
   elseif c == UInt8('c')
      command = :callfun
   else
      command = :undef
   end
   return (;command, prot_OK, prot_v)
end

# # # # # # #

function fromrowmajor(v, arrdims)
   revdims = Tuple(reverse(arrdims))
   neworder = length(revdims):-1:1
   arr = permutedims(reshape(v, revdims), neworder)
   return arr
end

function bin2num(;bin_data, nofbytes, start, arrdims, numtype)

   bin_data = bin_data[start:start+nofbytes-1]

   nt=Symbol(numtype)

   numtype=eval(nt)
   nums=numtype.(reinterpret(numtype, bin_data))
   if length(arrdims) > 1
      nums = fromrowmajor(nums, arrdims)
   end


   if eltype(nums) in (ComplexF32, ComplexF64)
      nums .= imag.(nums) .+ real.(nums)im
   end
   return nums

end


function bin2img(;bin_data, nofbytes, start, arrdims, numtype)

   bin_data = bin_data[start:start+nofbytes-1]

   if numtype == "img24bit"
      arrdims = Tuple(vcat(3, arrdims))
      nums = bin_data
      nums = reshape(bin_data, arrdims)
      nums = permutedims(nums, [1,3,2])
      nums = colorview(RGB, normedview(nums))
   else
      error("this image data type not supported")
   end

   return nums

end

function bin2nums(;bin_data, bindata_descr)

   function fbycat(ctg)
      fs = Dict("images"=>bin2img, "numarrays"=>bin2num)
      return fs[ctg]
   end

   arrs = [fbycat(bdd.category)(bin_data=bin_data, nofbytes=bdd.nofbytes, start=bdd.start, arrdims=bdd.arrdims, numtype=bdd.numtype) for bdd in bindata_descr]
   kwarg_names = [Symbol(bdd.kwarg_name) for bdd in bindata_descr]
   darrs = Dict(Pair.(kwarg_names,arrs))
   # @show darrs
   return darrs

end

# # # # # # #

mutable struct bindescr
   start::Int
   nofbytes::Int
   arrdims::Vector{Int}
   numtype::String
   kwarg_name::String
   category::String
end

bindescr() = bindescr(1,0,[],"", "", "numarrays")

function numtypestring(ar)
   t = eltype(ar)
   realtypes = (Float32, Float64, Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64)
   if t in realtypes
      return string(t)
   elseif t == ComplexF32  # special cases, as string(ComplexF32) is "Complex{Float32}"
      return "ComplexF32"
   elseif t == ComplexF64
      return "ComplexF64"
   else
      return nothing
   end
end


function nums2bin(; nums=Array{Number}, bin_data::Bytearr=Bytearr(), bdds::Vector{bindescr}=bindescr[], kwarg_name)
   @assert isempty(bin_data) == isempty(bdds)
   bdd = bindescr()
   bdd.kwarg_name = kwarg_name
   bdd.start = length(bin_data)+1
   bdd.numtype = numtypestring(nums)
   bdd.nofbytes = 32
   bdd.arrdims = collect(size(nums))
   push!(bdds, bdd)

return bin_data, bdds

end


# # # # # # #

function parse_REQ(b)

   opt_header = fun2call = json_data = json_dict = args = bin_data = bytearr_lng = nothing
   o_h_lng_start = 3
   bin_lng_start = o_h_lng_start + 4
   o_h_lng = bytar2int(b[o_h_lng_start:3+o_h_lng_start])
   bin_lng = bytar2int(b[bin_lng_start:3+bin_lng_start])

   o_h_start = bin_lng_start + 4
   if o_h_lng > 0
      opt_header = b[o_h_start:o_h_start+o_h_lng-1]
   end

   bin_start = o_h_start + o_h_lng
   if bin_lng > 0
      bin_data = b[bin_start:bin_start+bin_lng-1]
   end

   json_start = bin_start + bin_lng
   json_data = String(b[json_start:end])
   json_dict = Dict(JSON3.read(json_data))
   fun2call = Symbol(pop!(json_dict, :fun2call))
   args = json_dict # the rest
   if haskey(args, :bindata_descr)
      bindata_descr = pop!(args, :bindata_descr)
      numarrs = bin2nums(bin_data=bin_data, bindata_descr=bindata_descr)
      args = merge(args, numarrs)
   elseif !isnothing(bin_data)
      push!(args, :bin_data=>bin_data)
   end

   # @show ks=collect(keys(args))
   return (;
            opt_header,
            fun2call,
            args
            )
end

# numtype = "img24bit"
# img24bit = Array{UInt8,3}
#
# numtype=Symbol(numtype)
# numtype=eval(numtype)
#
# @show numtype == img24bit
