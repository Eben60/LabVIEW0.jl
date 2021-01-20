using Serialization
using JSON3
using Colors, TestImages, ImageIO, ImageShow, FileIO

function get_saved_img_bin()
    pth = raw"C:\_LabView_projects\ZMQ\LabView0mqJl.jl\src\Julia\this-and-that\sers.jsr"

    nbd = nbdd = nothing
    open(pth, "r") do io
        nbd=deserialize(io)
        nbdd=deserialize(io)
    end;

    return (; bin_data=nbd, bindata_descr=[nbdd])
end

function img_from_saved()
    bin2nums(;get_saved_img_bin()...)[:rgbimg]
end


# function fia(arr, seq)
#     arr = UInt8.(arr)
#     sec = UInt8.(seq)
#     ls = length(seq)
#     for i in 1:(lastindex(arr)-ls)
#         if arr[i:i+ls-1] == seq
#             return i
#         end
#     end
#     return nothing
# end

# bd = LabView0mqJl.data2bin(img, "kwn", [1,3,2]); println(bd==bd0); println(Int.(bd0[1:15])); println(Int.(bd[1:15]))
# typeof(prw) = Array{UInt8,3}
# size(rwv) = (3, 256, 256)
# false
# [129, 42, 63, 170, 62, 102, 157, 60, 95, 153, 55, 92, 156, 55, 99]
# [129, 42, 63, 170, 62, 102, 157, 60, 95, 153, 55, 92, 156, 55, 99]


# using LabView0mqJl
#
# nbd, = LabView0mqJl.get_saved_img_bin();
# img = LabView0mqJl.img_from_saved()
# bd = LabView0mqJl.data2bin(img, "kwn")
# bd == nbd
