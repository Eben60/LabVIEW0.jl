function myf4(;bin_data=nothing, arg1=10, arg2=31.4, int32=nothing)
   if !isnothing(bin_data)
      bin_lng = length(bin_data)
   else
      bin_lng = 0
   end
   a1 = arg1 * 10
   a2 = arg2 / 10.0
   return (; bin_lng, a1, a2)
end
