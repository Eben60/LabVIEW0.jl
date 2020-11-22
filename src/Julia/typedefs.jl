Bytearr = Vector{UInt8} # byte array

mutable struct bindescr
   start::Int
   nofbytes::Int
   arrdims::Vector{Int}
   numtype::String
   kwarg_name::String
   category::String
end

bindescr() = bindescr(1,0,[],"", "", "numarrays")
JSON3.StructTypes.StructType(::Type{bindescr}) = JSON3.StructTypes.Struct()
