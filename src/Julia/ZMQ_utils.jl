using JSON3, ImageCore

const PROTOC_V = UInt8(1)

if ! @isdefined bindescr
   include("./typedefs.jl")
end

include("./conversions.jl")


function get_script_path(p)
   global scriptexists
   srcdir = @__DIR__
   dummy = joinpath(srcdir, "dummy.jl")
   _, suffix = splitext(p)
   if suffix != ".jl"
      scriptexists = false
      return dummy
   elseif isfile(p)
      scriptexists = true
      return realpath(p)
   end

   p1 = joinpath(srcdir,p) # used for example scripts residing in the package

   if isfile(p1)
      scriptexists = true
      return p1
   else
      scriptexists = false
      return dummy
   end
end

function get_LVlib_path()
   srcdir = @__DIR__
   return joinpath(dirname(srcdir), "LabVIEW")
end

function StackFrame_to_NamedTuple(fm)
   # func::Symbol
   #    The name of the function containing the execution context.
   # linfo::Union{Core.MethodInstance, CodeInfo, Nothing}
   #    The MethodInstance containing the execution context (if it could be found).
   # file::Symbol
   #    The path to the file containing the execution context.
   # line::Int
   #    The line number in the file containing the execution context.
   # from_c::Bool
   #    True if the code is from C.
   # inlined::Bool
   #    True if the code is from an inlined frame.
   # pointer::UInt64
   return (frame_summary = string(fm),
          func=fm.func,
          linfo=string(fm.linfo),
          file=fm.file,
          line=fm.line,
          from_c=fm.from_c,
          inlined=fm.inlined,
          pointer=fm.pointer)
end

function err_dict(;err::Bool=false, errcode::Int=0, source::String="", stack_trace=[], excep="")
   if err
      # # default values on error
      if errcode == 0
         errcode = 5235805
      end



      # if stack_trace == ""
      #    stack_trace = "Julia script error"
      # end
   end

   if ! isempty(stack_trace)
      stack_trace = [StackFrame_to_NamedTuple(e) for e in stack_trace]
      # stack_trace = ["$e" for e in stack_trace]
   end



   return (;status=err, code=errcode, source=source, detailed_info=(excep=string(excep), trace=stack_trace))
end

function puttogether(;
                      y=Dict{Symbol, Any}(),
                      err=err_dict(),
                      opt_header::Bytearr=UInt8[],
                      returncode::Int=0
                      )


   returncode = UInt8(returncode)
   y = Dict{Symbol, Any}(pairs(y)) # y can be Dict or named tuple

   @assert haskey(err, :status) & haskey(err, :code) & haskey(err, :source) & haskey(err, :detailed_info)

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
