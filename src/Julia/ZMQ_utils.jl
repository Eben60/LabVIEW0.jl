using JSON3, ImageCore

const PROTOC_V = UInt8(1)

if ! @isdefined bindescr
   include("./typedefs.jl")
end

include("./conversions.jl")

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

function puttogether(;
                      y=Dict{Symbol, Any}(),
                      err=err_dict(),
                      opt_header::Bytearr=UInt8[],
                      returncode::Int=0
                      )


   returncode = UInt8(returncode)
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

   r = vcat(returncode, PROTOC_V, o_h_lng, bin_lng, opt_header, bin_data, jsonstring)

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
