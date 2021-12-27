using TestImages, ImageMagick

is2d_img(s) = ! any(occursin.(["_3d_", "series","stack"], lowercase(s)))

function get2d_images()
    rf = TestImages.remotefiles
    rf = filter(is2d_img, rf)
    return (;img_list=rf,)
end

function send_testimage(;img_name)
    img = testimage(img_name)
    img_type = string(typeof(img))
    return (;img_type, bigarrs=(;img))
end

fns = (;get2d_images, send_testimage, )
