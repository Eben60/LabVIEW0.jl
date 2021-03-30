function lineq(;m, v)
    s = m \ v
    return (; bigarrs=(; s, ))
end

fns = (; lineq, )
