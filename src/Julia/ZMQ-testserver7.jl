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

         pr = parse_REQ(bytesreceived)
         @show pr

         if ! pr.stop
            if pr.fun2call == :start
               println("told to start")
               response = UInt8.([0])
            else
               f = eval(pr.fun2call)
               y = f(; pr.args...)
               jsonstring = JSON3.write(y)
               response = puttogether(; jsonstring)
            end
         else
            response = UInt8.([1])
         end

         # Send reply back to client
         ZMQ.send(socket, response)

         pr.stop && break
      end


   catch y
      println("Exception: ", y)
      ZMQ.send(socket, UInt8.([255]))
      print(stacktrace())

   finally
      # clean up
      ZMQ.close(socket)
      ZMQ.close(context)
   end # try
end

ZMQ_server()
