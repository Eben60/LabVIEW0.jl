using Colors, TestImages, ImageIO, ImageShow, FileIO
using LV_ZMQ_Jl, Serialization

# img = testimage("lena_color_256")
# bd = LV_ZMQ_Jl.BinDescr(5, 25, [3,4], "mytype", "kvn", "mummarrays")
# sers = (;img, bd)

pth = raw"C:\_LabView_projects\ZMQ\LV_ZMQ_Jl.jl\src\Julia\this-and-that\sers.jsr"
      # joinpath(@__DIR__, "sers.jsr")


open(pth, "w") do io
    @show typeof(LV_ZMQ_Jl.gbd) typeof(LV_ZMQ_Jl.gbdd)
    serialize(io, LV_ZMQ_Jl.gbd)
    serialize(io, LV_ZMQ_Jl.gbdd)
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
