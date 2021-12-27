function loopback_arr(; kwargs...)
    return (; bigarrs = (;kwargs...))
end

fns = (; loopback_arr)
