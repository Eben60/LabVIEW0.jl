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

function bin2num(;bin_data=nothing,length=0, start=1, numtype="Float32")

   bin_data = bin_data[start:start+length-1]
   numtype=Symbol(numtype)
   numtype=eval(numtype)

   nums=numtype.(reinterpret(numtype, bin_data))
   return (; nums)

end

function bin2nums(;bin_data=nothing, bindata_descr=nothing)

   arrs = [bin2num(bin_data=bin_data, length=bdd.length, start=bdd.start, numtype=bdd.numtype).nums for bdd in bindata_descr]
   tags = [Symbol(bdd.tag) for bdd in bindata_descr]
   darrs = Dict(Pair.(tags,arrs))
   @show darrs
   return (; darrs)

end
