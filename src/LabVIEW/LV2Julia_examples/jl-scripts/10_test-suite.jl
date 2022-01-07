function loopbck2(; returnarrs=true, kwargs...)

    bigarrs = Dict(pairs(kwargs))

    eltypes = [string(eltype(ar)) for ar in values(bigarrs)]

    if returnarrs
        return (; bigarrs, eltypes)
    else
        return (; eltypes)
    end
end

fns = (; loopbck2)
