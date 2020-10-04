#!/usr/bin/env julia

#
# Hello World server in Julia
# Binds REP socket to tcp://*:5555
# Expects "Hello" from client, replies "World"
#

using ZMQ

# ZMQ.close()
context = Context()
socket = Socket(context, REP)
ZMQ.bind(socket, "tcp://*:5555")

global i=1
println("starting ZMQ server")

try
   for i = 1:20
      # Wait for next request from client
      message = String(ZMQ.recv(socket))
      println("Received request #$i: $message")

      # Do some 'work'

      # Send reply back to client
      if message == "start"
         response = "OK"
      elseif message == "stop"
         response = "stopping"
      else
         response = "$(i)th time: $message World"
      end


      ZMQ.send(socket, response)
      message == "stop" && break
   end

finally
   # classy hit men always clean up when finish the job.
   ZMQ.close(socket)
   ZMQ.close(context)
end # try
