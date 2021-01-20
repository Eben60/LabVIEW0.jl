using Colors, TestImages, ImageIO, ImageShow, FileIO
using LabView0mqJl, Serialization

# img = testimage("lena_color_256")
# bd = LabView0mqJl.BinDescr(5, 25, [3,4], "mytype", "kvn", "mummarrays")
# sers = (;img, bd)

pth = raw"C:\_LabView_projects\ZMQ\LabView0mqJl.jl\src\Julia\this-and-that\sers.jsr"
      # joinpath(@__DIR__, "sers.jsr")


open(pth, "w") do io
    @show typeof(LabView0mqJl.gbd) typeof(LabView0mqJl.gbdd)
    serialize(io, LabView0mqJl.gbd)
    serialize(io, LabView0mqJl.gbdd)
end;

# sers2=nothing
# open(pth, "r") do io
#     global sers2=deserialize(io)
#     # @show typeof(sers2)
# end;

nbd = nbdd = nothing
open(pth, "r") do io
    global nbd=deserialize(io)
    global nbdd=deserialize(io)

end;
@show typeof(nbd)
@show typeof(nbdd)
