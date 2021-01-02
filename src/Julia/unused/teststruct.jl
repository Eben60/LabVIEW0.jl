using JSON3

b1 = b2 = nothing
let
   mutable struct Bindescr
      start::Int
      nofbytes::Int
      arrdims::Vector{Int}
      numtype::String
      kwarg_name::String
      category::String
      # Bindescr() = new()
   end

   Bindescr() = Bindescr(1,0,[],"", "", "numarrays")

   global b1 = Bindescr(3,3,[],"Int16", "testarg", "numarrays")
   global b2 = Bindescr()


   JSON3.StructTypes.StructType(::Type{Bindescr}) = JSON3.StructTypes.Struct()
end
