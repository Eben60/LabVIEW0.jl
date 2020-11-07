using Colors, TestImages, ImageIO, ImageShow, FileIO, ImageCore

# see https://juliaimages.org

peppers = FileIO.load("src/Julia/this-and-that/peppers_color_256.png")

img = testimage("lena_color_256")
#img = testimage("lena_color_512")

display(img)

p55=img[5,5]
println(p55)
println(typeof(p55))
println(p55.r, p55.g, p55.b)

p55_g = reinterpret(UInt8, p55.g) # 0x85 = 133

cn = channelview(img)
r=reinterpret(UInt8, cn) #
println(r[:,5,5])
