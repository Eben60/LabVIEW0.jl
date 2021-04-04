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

function eigval(;m)
    s = ComplexF64.(eigen(m).values) # result is otherwise type unstable (float or complex), and LabVIEW can't handle it
    return (; bigarrs=(; s, ))
end


fns = (; lineq, eigval,)
