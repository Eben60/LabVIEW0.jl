using TestImages, ImageCore

img = testimage("lena_color_256")

cv = channelview(img)
r=collect(reinterpret(UInt8, cv))
@show typeof(r), size(r) # this is what I have

rc = Float32.(r/255.0)
im1 = colorview(RGB{N0f8}, r)
im2 = colorview(RGB{Float32}, rc)
display(im1)
