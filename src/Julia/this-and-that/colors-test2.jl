using TestImages, ImageCore

img = testimage("lena_color_256")

cv = channelview(img)
r=collect(reinterpret(UInt8, cv))
@show typeof(r), size(r) # this is what I have

# rc = r/255.0

# im2 = colorview(RGB, normedview(r))
# im2 = reinterpret(RGB{N0f8}, r)
im2 = colorview(RGB{N0f8}, r)
display(im2)
nothing
