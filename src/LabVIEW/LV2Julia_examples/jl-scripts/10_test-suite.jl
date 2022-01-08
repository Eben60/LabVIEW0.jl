using Primes, Random

function rndpw2(pw2)
    @assert pw2>=5
    r = rand()
    s = 0.5
        if pw2==5
            r = r/2
            s = 0
        end
    pw2 = pw2 + r - s
    b = Int(round(2^pw2))
end

function rndf3(n)
    while true
        n1 = rndpw2(n)
        fc = factor(Vector, n1)
        length(fc)>=3 && return fc
    end
end

function sizes2(vi)
    vi = shuffle(vi)
    l = length(vi)
    dv2 = rand(1:l-1)
    vi1 = vi[begin:dv2]
    vi2 = vi[dv2+1:end]
    return (prod(vi1), prod(vi2))
end

function sizes3(vi)
    vi = shuffle(vi)
    l = length(vi)
    while true
        dv2 = rand(1:l-1)
        dv3 = rand(1:l-1)
        dv2 != dv3 && break
    end
    if dv2>dv3
        dv2, dv3 = dv3, dv2
    end
    vi1 = vi[begin:dv2]
    vi2 = vi[dv2+1:dv3]
    vi3 = vi[dv3+1:end]
    return (prod(vi1), prod(vi2), prod(vi3))
end

# function testfunc(p; disp=true)
#     n = rndf3(p)
#     k = prod(n)
#     if disp
#         println(k, " ", n)
#     end
#     s2 = sizes2(n)
#     s3 = sizes3(n)
#     @assert prod(s2)==k
#     @assert prod(s3)==k
# end
#
# function testloop(it)
#     for i in 1:it
#         p = rand(5:25)
#         testfunc(p, disp=false)
#     end
# end
"""
    sizes123(; pw2)

Fancy way to make up 1D, 2D and 3D array sizes such that their
number of elements is equal. N of elements is random and approx 2^(pw2+-0.5).
Factorization of N into 2 and 3 terms is random as well.
"""
function sizes123(; pw2)
    n = rndf3(pw2)
    s1 = prod(n)
    s2 = sizes2(n)
    s3 = sizes3(n)
    @assert s1==prod(s2)==prod(s3)
    return (;sizes=(;s1, s2, s3))
end

#-----------------

function loopbck2(; returnarrs=true, testarr)

    bigarrs = (; testarr)

    el_type = string(eltype(testarr))
    arsize = size(testarr)

    ret = (; el_type, arsize)
    if returnarrs
        ret = merge((; bigarrs), ret)
    end
    return ret
end

fns = (; sizes123, loopbck2)
