using JSON3
using Colors, TestImages, ImageIO, ImageShow, FileIO, ImageCore

function show_img(lena=false)
   if lena
      img = testimage("lena_color_256")
   else
      img = FileIO.load("src/Julia/this-and-that/peppers_color_256.png")
   end

   display(img)
   return nothing
end


function myf1(;bin_data=nothing, arg1=10, arg2=31.4, int32=nothing)
   if !isnothing(bin_data)
      bin_lng = length(bin_data)
   else
      bin_lng = 0
   end
   a1 = arg1 * 10
   a2 = arg2 / 10.0
   return (; bin_lng, a1, a2)
end

function myf2(;bin_data=nothing, arg1=10, arg2=31.4, int32=nothing)
   if !isnothing(bin_data)
      bin_lng = length(bin_data)
   else
      bin_lng = 0
   end
   a1 = arg1 * 20
   a2 = arg2 / 5.0
   bin_data = Bytearr(1:8)
   return (; bin_lng, a1, a2, bin_data)
end

function myf3(;bin_data=nothing, arg1=10, arg2=31.4, int32=nothing)
   if !isnothing(bin_data)
      bin_lng = length(bin_data)
   else
      bin_lng = 0
   end
   a1 = arg1 * 30
   a2 = arg2 *3 / 10.0
   lena = (arg1>=2)
   show_img(lena)
   return (; bin_lng, a1, a2)
end

function test_bin2nums(;idx=1, testarr)
   a = testarr
   elem = nothing
   try
      elem = a[idx...]
      if typeof(elem) in (ComplexF32, ComplexF64)
         elem = (re=real.(elem), im=imag.(elem))
      end
   catch
      elem = -1
   end # try

   return (;elem)
end

function numarr_loopback(;idx=1, testarr)
   a = testarr
   elem = nothing
   try
      elem = a[idx...]
      if typeof(elem) in (ComplexF32, ComplexF64)
         elem = (re=real.(elem), im=imag.(elem))
      end
   catch
      elem = -1
   end # try
   # return (;bin_data, bdds)
   bin_data, bindata_descr = nums2bin(; nums=testarr, kwarg_name="testarr")
   return (;elem, bin_data, bindata_descr)
end


function test_rgbimg(;idx=1, rgbimg)
   display(rgbimg)
   elem = -1
   return (;elem)
end

# rgbimg
