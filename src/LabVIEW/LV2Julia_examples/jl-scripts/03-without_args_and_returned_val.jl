function hello_world_and_no_arguments(;)
    println("Hello World!")
    return (;) # Attention! If no values are to be returned, then return an empty named tuple.
end

fns = (;hello_world_and_no_arguments, )
