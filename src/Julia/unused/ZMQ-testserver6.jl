include("./ZMQ_utils.jl")

using ZMQ


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
         response = puttogether(bin_data=UInt8.([1,2,3,4]))

         ZMQ.send(socket, response)

         pr.stop && break
      end


   catch y
      println("Exception: ", y)
      ZMQ.send(socket, UInt8.([1]))
      print(stacktrace())

   finally
      # clean up
      ZMQ.close(socket)
      ZMQ.close(context)
   end # try
end

ZMQ_server()
