module Labview2Jl

using ZMQ, JSON3, ImageCore, Colors, PkgVersion

# version of the communication protocoll: First, and, presumably, the last as well
const PROTOC_V = 0x01

include("./Julia/ZMQ-server.jl")

# see setglobals() and get_script_path() using these globals
scriptexists = false
scriptOK = false
scriptexcep = nothing

export server_0mq4lv, get_script_path, setglobals, get_LVlib_path # functions
export scriptexists, scriptOK, scriptexcep # global variables

end
