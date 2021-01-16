# using Colors, TestImages, ImageIO, ImageShow, FileIO


function loopback(; kwargs...)
    defaults = (; idx = 1, showversion=true)
    kwargs = merge(defaults, kwargs)
    if kwargs.showversion
        version = 18
        println("version = $version")
    end

    scalarargs = [:idx, :showversion]
    bigarrs = Dict(pairs(kwargs))
    for arg in scalarargs
        delete!(bigarrs, arg)
    end
    # delete!(arrnames, :idx)
    # delete!(arrnames, :showversion)
    # @show arrnames

    elem = nothing
    # try

    if :testarr in keys(bigarrs)
        a=kwargs[:testarr]
    else
        first_arrkey = [(keys(bigarrs))...][1]
        a=kwargs[first_arrkey]
    end

    idx = kwargs[:idx]
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
    end

    if (typeof(a) <: AbstractArray{C,2} where C <: Color) && kwargs.showversion
        try
            display(a)
        catch
        end
    end

    return (; elem, bigarrs)
end

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
