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

function buildbin(sz=[24], tp=UInt8; kwn="nn")
   lng = prod(sz)
   bdd = bindescr(1, lng, sz, string(tp), kwn, "numarrays")
   ar1d = tp.(1:lng)
   bin_data = reinterpret(tp, ar1d)
   return (; bin_data, bdd)
end

# function b22n2b(ard)
#    bdd = bindescr(1, 24, ard, "UInt8", "nn", "numarrays")
#    bin_data = UInt8.(1:24)
#    nums = bin2nums(;bin_data=bin_data, bindata_descr=[bdd])[:nn]
#    # println(vec(Int.(nums)))
#
#    bd2, bdds = nums2bin(; nums=nums, kwarg_name="nn")
#    return (;bd2, bdd=bdds[1], nums=Int.(nums))
# end

function b2n2b(sz=[24], tp=UInt8; kwn="nn")
   bdin, bdd = buildbin(sz, tp; kwn=kwn)
   nums = bin2nums(;bin_data=bdin, bindata_descr=[bdd])[Symbol(kwn)]
   bdout, bdds = nums2bin(; nums=nums, kwarg_name=kwn)
   ok = bdin==bdout
   @show ok
   return (;ok, bdin, bdout, bdd=bdds[1], nums=Int.(nums))
end

# # # # # # #

function tocolmajor(arr)
   arrdims = size(arr)
   lng = length(arrdims)
   if lng > 1
      neworder = lng:-1:1
      arr = permutedims(arr, neworder)
   end
   return vec(arr)
end


function nums2Bytearr(nums)
   nums = tocolmajor(nums)
   return collect(reinterpret(UInt8, nums))
end


function nums2bin(; nums=Array{Number}, bin_data::Bytearr=Bytearr(), bdds::Vector{bindescr}=bindescr[], kwarg_name)
   @assert isempty(bin_data) == isempty(bdds)
   bdd = bindescr()
   bdd.kwarg_name = kwarg_name
   bdd.start = length(bin_data)+1
   bdd.numtype = numtypestring(nums)
   bdd.arrdims = collect(size(nums))
   bd = nums2Bytearr(nums)
   bdd.nofbytes = length(bd)
   bin_data = vcat(bin_data, bd)

   push!(bdds, bdd)

return (;bin_data, bdds)

end



ard = [2, 3, 4]
#ard = [4, 6]

# julia> bd2, _, _ = b2n2b(ard); println(Int.(bd2))
# [1, 13, 5, 17, 9, 21, 2, 14, 6, 18, 10, 22, 3, 15, 7, 19, 11, 23, 4, 16, 8, 20, 12, 24]

# 2D case
# p=permutedims(nums, (2,1));
# vec(p) # OK
# p=permutedims(nums, (3,2,1));
# vec(p) # OK too
