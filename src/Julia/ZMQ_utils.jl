using JSON3

LV_ZMQ_Jl_PROTOCOL_VERSION = UInt8(1)

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

function puttogether(;
                      bindata::Bytar=UInt8[],
                      jsonstring="{\"status\":false,\"source\":\"\",\"code\":0,\"longdescr\":\"\"}",
                      err=err_dict(),
                      opt_header::Bytar=UInt8[],
                      shorterrcode::Int=0
                      )

   err = Bytar(JSON3.write(err))
   if jsonstring != ""
      JSON3.read(jsonstring) # just to check validity; TODO - add error processing code
   end

   jsonstring = Bytar(jsonstring)
   # err = Bytar(err)

   shorterrcode = UInt8(shorterrcode)

   o_h_lng = int2bytar(length(opt_header))
   err_lng = int2bytar(length(err))
   bin_lng = int2bytar(length(bindata))
   js_lng = int2bytar(length(jsonstring))

   r = vcat(shorterrcode, LV_ZMQ_Jl_PROTOCOL_VERSION, o_h_lng, err_lng, bin_lng, opt_header, err, bindata, jsonstring)


   return r
end
