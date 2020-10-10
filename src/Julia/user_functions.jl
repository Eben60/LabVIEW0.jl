using JSON3

function myf1(;bin_data=nothing, arg1=10, arg2=31.4)
   if !isnothing(bin_data)
      bin_lng = length(bin_data)
   else
      bin_lng = 0
   end
   a1 = arg1 * 10
   a2 = arg2 / 10.0
   (; bin_lng, a1, a2)
end

function myf2(;bin_data=nothing, arg1=10, arg2=31.4)
   if !isnothing(bin_data)
      bin_lng = length(bin_data)
   else
      bin_lng = 0
   end
   a1 = arg1 * 20
   a2 = arg2 / 5.0
   (; bin_lng, a1, a2)
end

function myf3(;bin_data=nothing, arg1=10, arg2=31.4)
   if !isnothing(bin_data)
      bin_lng = length(bin_data)
   else
      bin_lng = 0
   end
   a1 = arg1 * 30
   a2 = arg2 *3 / 10.0
   (; bin_lng, a1, a2)
end
