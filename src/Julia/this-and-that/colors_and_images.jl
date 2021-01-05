using Colors, TestImages, ImageIO, ImageShow, FileIO, ImageCore

# see https://juliaimages.org

"""
size(nums) = (3, 256, 256)
typeof(nums) = Array{UInt8,3}
"""

peppers = FileIO.load("src/Julia/this-and-that/peppers_color_256.png")

#img = testimage("lena_color_256")
#img = testimage("lena_color_512")
img = peppers

# display(img)

p55=img[5,5]
@show p55
@show typeof(p55)
@show p55.r p55.g p55.b

p55_g = reinterpret(UInt8, p55.g) # 0x85 = 133

cn = channelview(img)
r = reinterpret(UInt8, cn) #
r2 = rawview(cn)
@show r == r2
r3 = normedview(r)
i3 = colorview(RGB, r3) # image again

ihsl = convert.(HSL, img) # hsl image
i_same = convert.(RGB{N0f8}, img)

@show r[:,5,5]

rc = collect(r)./255.0;
@show typeof(rc)
@show size(rc)

# normedview
# rawview


i2 = colorview(RGB, rc)

function isim(img::I) where I <: AbstractArray{C,2} where C <: Color # RGB
    isN0f8 = (eltype(img) <: RGB{N0f8})
    return (;isN0f8)
end
function isim(img)
    false
end
r1 = [1 2 3 4; 3 4 5 6]
g=r1.*2
b=r1.*3
rgb = zeros(3,2,4)
rgb[1,:,:] .= r1
rgb[2,:,:] .= g
rgb[3,:,:] .= b
rgb = UInt8.(rgb)
nrgb=normedview(rgb)
cl=colorview(RGB, nrgb)
@show isim(cl)
