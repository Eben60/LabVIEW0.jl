include("./ZMQ_utils.jl")

using ZMQ



context = Context()
socket = Socket(context, REP)
ZMQ.bind(socket, "tcp://*:5555")

println("starting ZMQ 1-req-server")

try

   # Wait for next request from client

   bytesreceived = ZMQ.recv(socket)

   br = Vector{UInt8}(bytesreceived)
   command = br[1]

   stop = command == UInt8('p')

   version = br[2]

   restb = br[3:end]


   # Send reply back to client

   response = puttogether(bindata=UInt8.([1,2,3,4]))



   ZMQ.send(socket, response)

catch

finally
   # clean up
   ZMQ.close(socket)
   ZMQ.close(context)
end # try
