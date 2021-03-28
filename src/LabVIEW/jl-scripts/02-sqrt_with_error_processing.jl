function sqrt_only_positive(;x)
    return (;sqrt=sqrt(x))
end

fns = (;sqrt_only_positive, ) # implicit field name: see https://docs.julialang.org/en/v1/base/base/#Core.NamedTuple
