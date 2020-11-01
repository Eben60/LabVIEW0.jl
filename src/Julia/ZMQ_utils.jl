using JSON3

const PROTOC_V = UInt8(1)

function err_dict(;err::Bool=false, errcode::Int=0, source::String="", longdescr::String="")
   if err
      # # default values on error
      if errcode == 0
         errcode = 5235805
      end
      if longdescr == ""
         longdescr = "Julia script error"
      end
   end

   return Dict("status"=>err, "code"=>errcode, "source"=>source, "longdescr"=>longdescr)
end

Bytar = Vector{UInt8} # byte array

function int2bytar(i::Int; i_type=UInt32)
   reinterpret(UInt8, [i_type(i)])
end

function bytar2int(b::Bytar; i_type=UInt32)
   i=reinterpret(i_type, b)[1]
end

function puttogether_untested(;
                      bin_data::Bytar=UInt8[],
                      y=Dict{Symbol, Any}(),
                      err=err_dict(),
                      opt_header::Bytar=UInt8[],
                      shorterrcode::Int=0
                      )


   shorterrcode = UInt8(shorterrcode)
   y = Dict(pairs(y)) # y can be Dict or named tuple
   ret = merge(y, err)
   jsonstring = Bytar(JSON3.write(ret))

   o_h_lng = int2bytar(length(opt_header))
   bin_lng = int2bytar(length(bin_data))
   js_lng = int2bytar(length(jsonstring))

   r = vcat(shorterrcode, PROTOC_V, o_h_lng, bin_lng, opt_header, bin_data, jsonstring)

   return r
end


function puttogether(;
                      bin_data::Bytar=UInt8[],
                      jsonstring="{\"status\":false,\"source\":\"\",\"code\":0,\"longdescr\":\"this is a looong description\"}",
                      err=err_dict(),
                      opt_header::Bytar=UInt8[],
                      shorterrcode::Int=0
                      )

   err = Bytar(JSON3.write(err))
   if jsonstring != ""
      JSON3.read(jsonstring) # just to check validity; TODO - add error processing code
   end

   jsonstring = Bytar(jsonstring)

   shorterrcode = UInt8(shorterrcode)

   o_h_lng = int2bytar(length(opt_header))
   err_lng = int2bytar(length(err))
   bin_lng = int2bytar(length(bin_data))
   js_lng = int2bytar(length(jsonstring))

   r = vcat(shorterrcode, PROTOC_V, o_h_lng, err_lng, bin_lng, opt_header, err, bin_data, jsonstring)


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

   numtype=Symbol(numtype)
   numtype=eval(numtype)

   nums=numtype.(reinterpret(numtype, bin_data))

   if length(arrdims) > 1
      nums = fromrowmajor(nums, arrdims)
   end

   if eltype(nums) in (ComplexF32, ComplexF64)
      nums .= imag.(nums) .+ real.(nums)im
      # numsre = real.(nums) # TODO later on these are not to be returned as JSON
      # numsin = imag.(nums) # then just return nums as array of complex numbers
      # return (; nums=(numsre, numsin))
   end
   return (; nums)

end

function bin2nums(;bin_data, bindata_descr)

   arrs = [bin2num(bin_data=bin_data, nofbytes=bdd.nofbytes, start=bdd.start, arrdims=bdd.arrdims, numtype=bdd.numtype).nums for bdd in bindata_descr]
   tags = [Symbol(bdd.tag) for bdd in bindata_descr]
   darrs = Dict(Pair.(tags,arrs))
   # @show darrs
   return darrs

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
