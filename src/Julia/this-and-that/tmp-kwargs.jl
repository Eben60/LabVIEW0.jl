function foo(;kwargs...)
    @show kwargs[:a]
    @show keys(kwargs)
    # if ! (:c in keys(kwargs))
    #     c=3
    # else
    #     c=kwargs[:c]
    # end
    c = get(kwargs, :c, 3)

    @show c
    return nothing
end
