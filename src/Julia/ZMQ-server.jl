include("./ZMQ_utils.jl")
include("./user_functions.jl")

using ZMQ


function ZMQ_server()

   context = Context()
   socket = Socket(context, REP)
   ZMQ.bind(socket, "tcp://*:5555")

   println("starting ZMQ server: Julia for LabVIEW")
   try
      while true
         # Wait for next request from client

         bytesreceived = ZMQ.recv(socket)

         cmnd = parse_cmnd(bytesreceived)
         # @show cmnd
         response = UInt8[]
         if cmnd.command == :stop
            response = UInt8.([1, PROTOC_V])
         elseif cmnd.command == :ping
            response = UInt8.([2, PROTOC_V])
         elseif cmnd.command == :callfun
            try
               pr = parse_REQ(bytesreceived)
               f = eval(pr.fun2call)
               y = f(; pr.args...)
               jsonstring = JSON3.write(y)
               response = puttogether(; y=y)
            catch y
               # println(string(y))
               err_stack_trace = stacktrace(catch_backtrace())
               # # https://docs.julialang.org/en/v1/manual/stacktraces/#Error-handling-1
               # stack_trace = "Exception: $y ; stacktrace: $(stacktrace())"
               err = err_dict(;err=true, errcode=5235805, source=@__FILE__ , stack_trace=err_stack_trace, excep=y)
               response = puttogether(; err=err, returncode=3)
            end
         else
            response = UInt8.([255, PROTOC_V])
         end

         # Send reply back to client
         ZMQ.send(socket, response)

         cmnd.command==:stop && break
      end

   finally
      # clean up
      ZMQ.close(socket)
      ZMQ.close(context)
   end # try
   # # clean up
   # ZMQ.close(socket)
   # ZMQ.close(context)


end

# ZMQ_server()
