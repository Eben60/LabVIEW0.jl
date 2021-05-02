"""
    loopback(; showversion=false, idx=-1, kwargs...)

Return all "binary-encoded" arrays without change. For a positive `idx` also return
a (JSON-encoded) element of one of these arrays. Used for testing.
"""
function loopback(; showversion=false, idx=-1, kwargs...)
    # showversion kwarg included for compatibility, but ignored
    # TODO remove it later

    bigarrs = Dict(pairs(kwargs))

    if idx < 0
        return (; bigarrs)
    end

    # otherwise return an element

    if :testarr in keys(bigarrs)
        a=kwargs[:testarr]
    else
        first_arrkey = sort([(keys(bigarrs))...])[1] # first by alphabet
        a=kwargs[first_arrkey]
    end

    elem = -1
    if ! isimage(a)
        try
            elem = a[idx...]
            if typeof(elem) in (ComplexF32, ComplexF64)
                elem = (re = real.(elem), im = imag.(elem))
            elseif elem isa Bool
                elem = UInt8(elem)
            end
        catch
        end
    end

    return (; elem, bigarrs)
end
