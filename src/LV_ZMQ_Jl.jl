module LV_ZMQ_Jl

using JSON3, ImageCore, ZMQ

include("./Julia/ZMQ-server.jl")

scriptexists = false
scriptOK = true
scriptexcep = nothing

export ZMQ_server, get_script_path # functions
export scriptexists, scriptOK, scriptexcep # global variables

end
