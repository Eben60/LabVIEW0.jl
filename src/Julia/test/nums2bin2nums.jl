include("../ZMQ_utils.jl")

function n2b2n(ar)
   bin_data, bdds = nums2bin(; nums=ar, kwarg_name="nn")
   @show bdds[1]
   # bin2nums(;bin_data=bin_data, bindata_descr=bdds)
   bin2nums(;bin_data=UInt8.(collect(1:24)), bindata_descr=bdds)

end

# ar=collect(1:24)
# ar=UInt8.(collect(1:24))
# ar3=reshape(ar, (2,3,4))
# ar2=reshape(ar, (4,6))
#
# aa2 = Int.(n2b2n(ar2)[:nn])
# aa3 = Int.(n2b2n(ar3)[:nn])
#
# ari2 = Int.(ar2)
# ari3 = Int.(ar3)

function b2n2b(ard)
   bdd = bindescr(1, 24, ard, "UInt8", "nn", "numarrays")
   bin_data = UInt8.(1:24)
   nums = bin2nums(;bin_data=bin_data, bindata_descr=[bdd])[:nn]

   bd2, bdds = nums2bin(; nums=nums, kwarg_name="nn")
   return (;bd2, bdd=bdds[1], nums)

end

ard = [2, 3, 4]

# julia> bd2, _, _ = b2n2b(ard); println(Int.(bd2))
# [1, 13, 5, 17, 9, 21, 2, 14, 6, 18, 10, 22, 3, 15, 7, 19, 11, 23, 4, 16, 8, 20, 12, 24]
