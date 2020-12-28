function foo(;kwargs...)
    @show kwargs[:a]
    @show keys(kwargs)
    # if ! (:c in keys(kwargs))
    #     c=3
    # else
    #     c=kwargs[:c]
    # end
    #
    #
    # c = get(kwargs, :c, 3) # alternative solution
    #
    #
    defaults = (;c=3)
    kwargs = merge(defaults, kwargs)
    newkeys = Set(keys(kwargs))
    delete!(keys(kwargs), :b)
    @show newkeys
    c = kwargs.c
    @show c
    return nothing
end
