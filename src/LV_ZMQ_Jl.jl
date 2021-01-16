module LV_ZMQ_Jl

using ZMQ, JSON3, ImageCore, Colors, PkgVersion

include("./Julia/ZMQ-server.jl")
include("./JUlia/precompiles.jl")

scriptexists = false
scriptOK = false
scriptexcep = nothing

export server_0mq4lv, get_script_path, setglobals, get_LVlib_path # functions
export scriptexists, scriptOK, scriptexcep # global variables

end
