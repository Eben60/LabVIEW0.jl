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

# TODO probably these not used any more

function foo(;arg1, arg2_string, arg3_arr_Cx32, arg4_arr_i16)

    # doing some stuff, e.g. check if we got the right data type
    @assert typeof(arg3_arr_Cx32) == Array{Complex{Float32},2}
    @assert typeof(arg4_arr_i16) == Vector{Int16}
    # some more stuff

    # get data to return, e.g.
    resp1 = rand()
    resp_arr_I32 = Int32.(vcat(arg4_arr_i16, [1,2,3]))
    resp_arr_F64 = arg1.*abs.(vec(arg3_arr_Cx32)) .+ sqrt(2)


    return (;resp1, bigarrs=(;resp_arr_I32, resp_arr_F64))
end

function tmp_test(x)
    return x
end
