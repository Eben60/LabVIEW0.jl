include("../ZMQ_utils.jl")

function n2b2n(ar)
    bin_data, bdds = nums2bin!(; nums = ar, kwarg_name = "nn")
    @show bdds[1]
    # bin2nums(;bin_data=bin_data, bindata_descr=bdds)
    bin2nums(; bin_data = UInt8.(collect(1:24)), bindata_descr = bdds)

end

function buildbin(sz = [24], tp = UInt8; kwn = "nn")
    lng = prod(sz)
    ar1d = tp.(1:lng)
    if tp in (ComplexF32, ComplexF64)
        ar1d = cmplxswap.(ar1d)
    end
    bin_data = reinterpret(UInt8, ar1d)
    if tp == ComplexF32
        tpstr = "ComplexF32"
    elseif tp == ComplexF64
        tpstr = "ComplexF64"
    else
        tpstr = string(tp)
    end

    bdd = Bindescr(1, length(bin_data), sz, tpstr, kwn, "numarrays")
    return (; bin_data, bdd)
end


function b2n2b(sz = [24], tp = UInt8; kwn = "nn")
    bdin, bddin = buildbin(sz, tp; kwn = kwn)
    @show bddin
    nums = bin2nums(; bin_data = bdin, bindata_descr = [bddin])[Symbol(kwn)]
    bdout, bdds = nums2bin!(; nums = nums, kwarg_name = kwn)
    ok = bdin == bdout
    @show ok
    return (; ok, bdin, bdout, bddin, bddout = bdds[1], nums, numsint = Int.(abs.(nums)))
end
