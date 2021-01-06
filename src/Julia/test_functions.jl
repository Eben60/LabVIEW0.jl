function loopback(; kwargs...)
    defaults = (; idx = 1, showversion=true)
    kwargs = merge(defaults, kwargs)
    if kwargs.showversion
        version = 18
        println("version = $version")
    end

    scalarargs = [:idx, :showversion]
    arrnames = Set(keys(kwargs))
    for arg in scalarargs
        delete!(arrnames, arg)
    end
    # delete!(arrnames, :idx)
    # delete!(arrnames, :showversion)
    # @show arrnames
    
    testarr = kwargs[:testarr]
    idx = kwargs[:idx]
    a = testarr
    elem = nothing
    # println("p2")
    try
        elem = a[idx...]
        if typeof(elem) in (ComplexF32, ComplexF64)
            elem = (re = real.(elem), im = imag.(elem))
        elseif elem isa Bool
            elem = UInt8(elem)
        end
    catch
        elem = -1
    end # try
    # println("p3")

    return (; elem, bigarrs = kwargs)
end
