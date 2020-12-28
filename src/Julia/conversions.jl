using JSON3, ImageCore

if ! @isdefined bindescr
   include("./typedefs.jl")
end

# # # # # # # #

function int2bytar(i::Int; i_type=UInt32)
   reinterpret(UInt8, [i_type(i)])
end

function bytar2int(b::Bytearr; i_type=UInt32)
   i=reinterpret(i_type, b)[1]
end

function numtypestring(ar)
   t = eltype(ar)
   realtypes = (Float32, Float64, Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64)
   if t in realtypes
      return string(t)
   elseif t == ComplexF32  # special cases, as string(ComplexF32) is "Complex{Float32}"
      return "ComplexF32"
   elseif t == ComplexF64
      return "ComplexF64"
   else
      return throw(DomainError("$(string(t)) is not a supported numeric type for exchange with LabVIEW. consider converting array first."))
   end
end

function fromrowmajor(v, arrdims)
   revdims = Tuple(reverse(arrdims))
   neworder = length(revdims):-1:1
   arr = permutedims(reshape(v, revdims), neworder)
   return arr
end

function fromcolmajor(v, arrdims)
   revdims = Tuple(reverse(arrdims))
   neworder = length(revdims):-1:1
   arr = permutedims(reshape(v, revdims), neworder)
   return arr
end

function cmplxswap(c::Complex)
   c = imag(c) + real(c)im
   return c
end

function bin2num(;bin_data, nofbytes, start, arrdims, numtype)

   bin_data = bin_data[start:start+nofbytes-1]

   nt=Symbol(numtype)

   numtype=eval(nt)
   nums=collect(reinterpret(numtype, bin_data))
   if length(arrdims) > 1
      nums = fromrowmajor(nums, arrdims)
   end

   if eltype(nums) in (ComplexF32, ComplexF64)
      nums .= cmplxswap.(nums)
   end
   return nums

end

function bin2img(;bin_data, nofbytes, start, arrdims, numtype)

   bin_data = bin_data[start:start+nofbytes-1]

   if numtype == "img24bit"
      arrdims = Tuple(vcat(3, arrdims))
      nums = bin_data
      nums = reshape(bin_data, arrdims)
      nums = permutedims(nums, [1,3,2])
      nums = colorview(RGB, normedview(nums))
   else
      throw(DomainError("image data type ($numtype) not supported"))
   end

   return nums

end

function bin2nums(;bin_data, bindata_descr)

   function fbycat(ctg)
      fs = Dict("images"=>bin2img, "numarrays"=>bin2num)
      return fs[ctg]
   end

   arrs = [fbycat(bdd.category)(bin_data=bin_data, nofbytes=bdd.nofbytes, start=bdd.start, arrdims=bdd.arrdims, numtype=bdd.numtype) for bdd in bindata_descr]
   kwarg_names = [Symbol(bdd.kwarg_name) for bdd in bindata_descr]
   darrs = Dict(Pair.(kwarg_names,arrs))
   # @show darrs
   return darrs

end

# # # # # # # #

function tocolmajor(arr)
   arrdims = size(arr)
   lng = length(arrdims)
   if lng > 1
      neworder = lng:-1:1
      arr = permutedims(arr, neworder)
   end
   return vec(arr)
end

function nums2Bytearr(nums)
   nums = tocolmajor(nums)
   return collect(reinterpret(UInt8, nums))
end

function nums2bin(; nums=Array{Number}, bin_data::Bytearr=Bytearr(), bindata_descr::Vector{bindescr}=bindescr[], kwarg_name)
   @assert isempty(bin_data) == isempty(bindata_descr)
   bdd = bindescr()
   bdd.kwarg_name = kwarg_name
   bdd.start = length(bin_data)+1
   bdd.numtype = numtypestring(nums)
   if eltype(nums) <: Complex
      nums .= cmplxswap.(nums)
   end
   bdd.arrdims = collect(size(nums))
   bd = nums2Bytearr(nums)
   bdd.nofbytes = length(bd)
   bin_data = vcat(bin_data, bd)
   push!(bindata_descr, bdd)
   return (;bin_data, bindata_descr)
end
