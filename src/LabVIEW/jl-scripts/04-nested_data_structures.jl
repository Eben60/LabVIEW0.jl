function multiply_all(;text_data, num_data)
    f = num_data.factor
    a = num_data.num_arr
    t1 = text_data^f
    a1 = a .* f
    f1 = f^2
    return (;text_data=t1, num_data=(factor=f1, num_arr=a1))
end

fns = (;multiply_all, )
