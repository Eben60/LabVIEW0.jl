using JSON3

b1 = b2 = nothing
let
   mutable struct BinDescr
      start::Int
      nofbytes::Int
      arrdims::Vector{Int}
      numtype::String
      kwarg_name::String
      category::String
      # BinDescr() = new()
   end

   BinDescr() = BinDescr(1,0,[],"", "", "numarrays")

   global b1 = BinDescr(3,3,[],"Int16", "testarg", "numarrays")
   global b2 = BinDescr()


   JSON3.StructTypes.StructType(::Type{BinDescr}) = JSON3.StructTypes.Struct()
end
