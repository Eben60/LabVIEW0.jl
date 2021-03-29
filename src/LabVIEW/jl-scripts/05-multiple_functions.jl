function addition(;x, y)
    result = x+y
    return (;result)  # implicit field name
end

function subtraction(;x, y)
    result = x-y
    return (;result)
end

function multiplication(;x, y)
    result = x*y
    return (;result)
end

function division(;x, y)
    result = x/y
    return (;result)
end

function conquer(;kwargs...) # the function MUST accept all keyword arguments passed to it, but is not obliged to process them
    result = +Inf
    return (;result)
end


fns = (;addition, subtraction, multiplication, division, conquer)
