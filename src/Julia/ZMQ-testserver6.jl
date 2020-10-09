include("./ZMQ_utils.jl")

using ZMQ

function parse_REQ(b)
   command = b[1]
   stop = command == UInt8('p')
   fun2call = json_dict = bytearr= bytearr_lng = version = nothing
   bytearr_start = 7

   if ! stop
      version = b[2]
      bytearr_lng = bytar2int(b[3:6])
      if bytearr_lng > 0
         bytearr = b[bytearr_start:bytearr_start+bytearr_lng-1]
      end
      json_data = String(b[bytearr_start+bytearr_lng:end])
      json_dict = Dict(JSON3.read(json_data))
      fun2call = Symbol(pop!(json_dict, :fun2call))
   end
   return (stop=stop, version, bytearr_lng, bytearr, json_dict, fun2call, args=json_dict)
end


function ZMQ_server()

   context = Context()
   socket = Socket(context, REP)
   ZMQ.bind(socket, "tcp://*:5555")

   println("starting ZMQ 1-req-server")

   try
      for i = 1:20
         # Wait for next request from client

         bytesreceived = ZMQ.recv(socket)
         # br = Vector{UInt8}(bytesreceived)
         @show pr = parse_REQ(bytesreceived)

         # Send reply back to client
         response = puttogether(bindata=UInt8.([1,2,3,4]))

         ZMQ.send(socket, response)

         pr.stop && break
      end


   catch y
      println("Exception: ", y)
      ZMQ.send(socket, UInt8.([1]))

   finally
      # clean up
      ZMQ.close(socket)
      ZMQ.close(context)
   end # try
end

ZMQ_server()
