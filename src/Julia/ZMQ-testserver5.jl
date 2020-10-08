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
         br = Vector{UInt8}(bytesreceived)
         command = br[1]
         stop = command == UInt8('p')
         if ! stop
            version = br[2]
            restb = br[3:end]
         end

         # Send reply back to client
         response = puttogether(bindata=UInt8.([1,2,3,4]))

         ZMQ.send(socket, response)

         stop && break
      end

   catch

   finally
      # clean up
      ZMQ.close(socket)
      ZMQ.close(context)
   end # try
end

ZMQ_server()
