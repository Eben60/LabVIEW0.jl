function hello_world_and_no_arguments(;) # Attention! The function must accept keyword arguments, therefore semicolon. Here just a zero number of kwargs
    println("Hello World!")
    return (;) # Attention! If no values are to be returned, then return an empty named tuple.
end

fns = (;hello_world_and_no_arguments, )
