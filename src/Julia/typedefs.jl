Bytearr = Vector{UInt8} # byte array

"""
    Bindescr

Describe (a chunk) of binary data, e.g. numeric array or image in the LV_ZMQ_Jl format used
for exchange between Julia and LabVIEW. Gets converted from/to JSON for transport.
"""
mutable struct Bindescr
    start::Int
    nofbytes::Int
    arrdims::Vector{Int}
    numtype::String
    kwarg_name::Union{String,Symbol}
    category::String
end

Bindescr() = Bindescr(1, 0, [], "", "", "numarrays")
JSON3.StructTypes.StructType(::Type{Bindescr}) = JSON3.StructTypes.Struct()
