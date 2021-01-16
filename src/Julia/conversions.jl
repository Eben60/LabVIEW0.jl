SUPPORTED_REALS = (
    Float32, Float64,
    Int8, Int16, Int32, Int64,
    UInt8, UInt16, UInt32, UInt64,
    Bool,
    )
SUPPORTED_COMPLEX = (ComplexF32, ComplexF64)

# if !@isdefined BinDescr
#     include("./typedefs.jl")
# end

# # # # # # # #

function int2bytar(i::Int; i_type = UInt32)
    if i_type == Bool
        return UInt8(Bool)
    else
        return reinterpret(UInt8, [i_type(i)])
    end
end

function bytar2int(b::ByteArr; i_type = UInt32)
    if i_type != Bool
        return reinterpret(i_type, b)[1]
    else
        return Bool(b[1])
    end
end

function numtypestring(ar)
    t = eltype(ar)
    realtypes =
        (Float32, Float64, Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64, Bool)
    if t in realtypes
        return string(t)
    elseif t == ComplexF32  # special cases, as string(ComplexF32) is "Complex{Float32}"
        return "ComplexF32"
    elseif t == ComplexF64
        return "ComplexF64"
    else
        return throw(DomainError("$(string(t)) is not a supported numeric type for exchange with LabVIEW: consider converting array first."))
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

function emptyarr(arrdims, numtype)
    Array{numtype}(undef, zeros(Int, length(arrdims))...)
end

function bin2num(; bin_data, nofbytes, start, arrdims, numtype)
    nt = Symbol(numtype)
    numtype = eval(nt)

    if nofbytes == 0 || any(arrdims.==0)
        return emptyarr(arrdims, numtype)
    end

    bin_data = bin_data[start:start+nofbytes-1]

    if numtype != Bool
        nums = collect(reinterpret(numtype, bin_data))
    else
        nums = Bool.(bin_data)
    end

    if length(arrdims) > 1
        nums = fromrowmajor(nums, arrdims)
    end

    if eltype(nums) in (ComplexF32, ComplexF64)
        nums .= cmplxswap.(nums)
    end
    return nums
end


function bin2img(; bin_data, nofbytes, start, arrdims, numtype)

    if nofbytes == 0 || any(arrdims.==0)
        T = typeof(RGB(0,0,0)) # type by example
        return emptyarr(arrdims, T)
    end

    bin_data = bin_data[start:start+nofbytes-1]

    if numtype == "img24bit"
        arrdims = (3, arrdims[2], arrdims[1])
        nums = bin_data
        nums = reshape(bin_data, arrdims)
        nums = permutedims(nums, [1, 3, 2])
        nums = colorview(RGB, normedview(nums))
    else
        throw(DomainError("image data type ($numtype) not supported"))
    end

    return nums
end

function fn_by_category(ctg)
    fs = Dict("images" => bin2img, "numarrays" => bin2num)
    return fs[ctg]
end

"""
   bin2nums(; bin_data, bindata_descr)

Get data as received from LabVIEW (binary + array of decriptions) and return a
dictionary of de-serialized arrays (or other supported data types, e.g. images).
The dictionary items meant to be supplied as kwargs to user functions.
"""
function bin2nums(; bin_data, bindata_descr)
    arrs = [
        fn_by_category(bdd.category)(
            bin_data = bin_data,
            nofbytes = bdd.nofbytes,
            start = bdd.start,
            arrdims = bdd.arrdims,
            numtype = bdd.numtype,
        ) for bdd in bindata_descr
    ]
    kwarg_names = [Symbol(bdd.kwarg_name) for bdd in bindata_descr]
    darrs = Dict(Pair.(kwarg_names, arrs))
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

function nums2ByteArr(nums)
    nums = tocolmajor(nums)
    if eltype(nums) == Bool
        return UInt8.(nums)
    else
        return collect(reinterpret(UInt8, nums))
    end
end

function data2bin(img::I, kwarg_name) where I <: AbstractArray{C,2} where C <: Color
    img = convert.(RGB{N0f8}, img)
    cnv = channelview(img)
    rwv = collect(rawview(cnv))
    prw = collect(permutedims(rwv, [1,3,2]))
    bd = vec(prw)

    bdd = BinDescr()
    bdd.kwarg_name = kwarg_name
    bdd.numtype = "img24bit"
    bdd.arrdims = collect(size(img))
    bdd.nofbytes = length(bd)
    return (bd, bdd)
end

function data2bin(arrdata, kwarg_name)
    bdd = BinDescr()
    bdd.kwarg_name = kwarg_name
    bdd.numtype = numtypestring(arrdata)
    if eltype(arrdata) <: Complex
        arrdata .= cmplxswap.(arrdata)
    end
    bdd.arrdims = collect(size(arrdata))
    bd = nums2ByteArr(arrdata)
    bdd.nofbytes = length(bd)
    return (bd, bdd)
end

"""
   data2bin!!(bin_data::ByteArr, bindata_descr::Vector{BinDescr}; arrdata, kwarg_name)

Serialize for exchange with LabVIEW: Compute binary representation and
description of data (currently supported types are numeric arrays and images).
Append the binary representation to `bin_data`, and description to
`bindata_descr` array (if the first two arguments are provided, mutate them,
otherwise create).
"""
function data2bin!!(
    bin_data::ByteArr = ByteArr(),
    bindata_descr::Vector{BinDescr} = BinDescr[];
    arrdata,
    kwarg_name,
)
    @assert isempty(bin_data) == isempty(bindata_descr)
    bd, bdd = data2bin(arrdata, kwarg_name)
    bdd.start = length(bin_data) + 1
    bin_data = vcat(bin_data, bd)
    push!(bindata_descr, bdd)
    return (; bin_data, bindata_descr)
end

"""
   nums2bin(arrs)

Accept an iterable of array-like data (numeric arrays, images, anything to come...). Compute
binary representation and description for them and return binary data and array of
descriptions, ready to be sent to LabVIEW.
"""
function nums2bin(arrs)
    bin_data = ByteArr()
    bindata_descr = BinDescr[]

    for arrname in keys(arrs)
        bin_data, bindata_descr =
            data2bin!!(bin_data, bindata_descr; arrdata = arrs[arrname], kwarg_name = arrname)
    end
    return (; bin_data, bindata_descr)
end
