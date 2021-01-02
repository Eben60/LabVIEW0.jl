module LV_ZMQ_Jl

using JSON3, ImageCore, ZMQ

include("./Julia/ZMQ-server.jl")

scriptexists = false
scriptOK = false

export ZMQ_server, get_script_path, scriptexists, scriptOK

end
