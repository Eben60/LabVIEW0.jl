function foo(;kwargs...)
    @show kwargs[:a]
    @show keys(kwargs)
    if ! (:c in keys(kwargs))
        c=3
    else
        c=kwargs[:c]
    end
    @show c
end
