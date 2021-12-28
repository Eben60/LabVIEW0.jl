ByteArr = Vector{UInt8} # byte array

"""
    BinDescr

Describe (a chunk) of binary data, e.g. numeric array or image in the Labview2Jl format used
for exchange between Julia and LabVIEW. Gets converted from/to JSON for transport.
"""
mutable struct BinDescr
    nofbytes::Int
    numtype::String
    start::Int
    arrdims::Vector{Int}
    kwarg_name::Union{String,Symbol}
    category::String
end

BinDescr() = BinDescr(0, "", 1, [], "", "numarrays")
JSON3.StructTypes.StructType(::Type{BinDescr}) = JSON3.StructTypes.Struct()
