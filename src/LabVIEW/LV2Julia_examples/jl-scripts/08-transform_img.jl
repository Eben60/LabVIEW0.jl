function transform_img(; img, flip_lr=false, flip_ud=false, negative=false)
    if flip_lr
        img = reverse(img, dims=2)
    end

    if flip_ud
        img = reverse(img, dims=1)
    end

    if negative
        img = map(x->typeof(x)(1-x.r,1-x.g,1-x.b), img) # works probably for RGB images only
    end

    return (; bigarrs = (;img, ))
end

fns = (; transform_img)
