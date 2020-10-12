include("./ZMQ_utils.jl")
include("./user_functions.jl")

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

         cmnd = parse_cmnd(bytesreceived)
         @show cmnd

         if cmnd.command == :stop
            response = UInt8.([1, PROTOC_V])
         elseif cmnd.command == :ping
            response = UInt8.([2, PROTOC_V])
         elseif cmnd.command == :callfun
            pr = parse_REQ(bytesreceived)
            @show pr
            f = eval(pr.fun2call)
            y = f(; pr.args...)
            jsonstring = JSON3.write(y)
            response = puttogether(; jsonstring)
         else
            response = UInt8.([254, PROTOC_V])
         end

         # Send reply back to client
         ZMQ.send(socket, response)

         cmnd.command==:stop && break
      end


   catch y
      println("Exception: ", y)
      response = UInt8.([255, PROTOC_V])
      ZMQ.send(socket, response)
      print(stacktrace())

   finally
      # clean up
      ZMQ.close(socket)
      ZMQ.close(context)
   end # try
end

ZMQ_server()
