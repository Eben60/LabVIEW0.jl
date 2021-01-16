# const SUPPORTED_REALS = (
#     Float32, Float64,
#     Int8, Int16, Int32, Int64,
#     UInt8, UInt16, UInt32, UInt64,
#     Bool,
#     )
# const SUPPORTED_COMPLEX = (ComplexF32, ComplexF64)

function supported_arr_types()
    scalars = (SUPPORTED_REALS..., SUPPORTED_COMPLEX...)
    arr_types = [Array{T, I} for T in scalars, I in 1:3]

end

types = supported_arr_types()

for T in types
    precompile(nums2ByteArr, (T,))
end
