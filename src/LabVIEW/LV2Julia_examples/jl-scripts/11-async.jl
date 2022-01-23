function add_two_numbers(;x, y)
    x_plus_y = x+y
    sleep(10)
    return (;x_plus_y=x_plus_y) # a NamedTuple must be returned
end

fns = (;add_two_numbers=add_two_numbers, )
