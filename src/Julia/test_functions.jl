function loopback(; kwargs...)
    defaults = (; idx = 1, showversion=true)
    if showversion
        version = 18
        println("version = $version")
    end
    kwargs = merge(defaults, kwargs)

    arrnames = Set(keys(kwargs))
    delete!(arrnames, :idx)
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
