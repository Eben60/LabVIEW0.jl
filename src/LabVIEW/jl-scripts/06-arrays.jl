using LinearAlgebra

function lineq(;m, v, invert=false)
    s = m \ v
    if ! invert
        return (; bigarrs=(; s, ))
    else
        invm=inv(m)
        detm = det(m)
        return (; detm, bigarrs=(; s, invm), )
    end
end

fns = (; lineq, )
