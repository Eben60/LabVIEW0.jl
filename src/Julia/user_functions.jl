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

function arrlength(ar)
   return length(ar)
end

function bin2num(;bin_data=nothing, nofbytes, start, arrdims, numtype)

   bin_data = bin_data[start:start+nofbytes-1]

   numtype=Symbol(numtype)
   numtype=eval(numtype)

   nums=numtype.(reinterpret(numtype, bin_data))

   @show length(nums)

   if length(arrdims) > 1
      arrdims = Tuple(reverse(arrdims))
      nums = transpose(reshape(nums, arrdims)) #2D only; see https://discourse.julialang.org/t/should-reshape-have-an-option-for-row-major-order/6929
   end


   if eltype(nums) in (ComplexF32, ComplexF64)
      nums .= imag.(nums) .+ real.(nums)im
      numsre = real.(nums) # TODO later on these are not to be returned as JSON
      numsin = imag.(nums) # then just return nums as array of complex numbers
      return (; nums=(numsre, numsin))
   else
      return (; nums)
   end
end

function bin2nums(;bin_data=nothing, bindata_descr=nothing)

   arrs = [bin2num(bin_data=bin_data, nofbytes=bdd.nofbytes, start=bdd.start, arrdims=bdd.arrdims, numtype=bdd.numtype).nums for bdd in bindata_descr]
   tags = [Symbol(bdd.tag) for bdd in bindata_descr]
   darrs = Dict(Pair.(tags,arrs))
   @show darrs
   return (; darrs)

end
