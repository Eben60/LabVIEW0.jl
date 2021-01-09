using Colors, TestImages, ImageIO, ImageShow, FileIO
using LV_ZMQ_Jl, Serialization

img = testimage("lena_color_256")
bd = LV_ZMQ_Jl.BinDescr(5, 25, [3,4], "mytype", "kvn", "mummarrays")
sers = (;img, bd)

pth = raw"C:\_LabView_projects\ZMQ\LV_ZMQ_Jl.jl\src\Julia\this-and-that\sers.jsr"
      # joinpath(@__DIR__, "sers.jsr")


open(pth, "w") do io
    serialize(io, sers)
end;

sers2=nothing
open(pth, "r") do io
    global sers2=deserialize(io)
    # @show typeof(sers2)
end;
@show typeof(sers2)
