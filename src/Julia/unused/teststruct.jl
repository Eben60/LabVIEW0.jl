b1 = b2 = nothing
let
   mutable struct bindescr
      start::Int
      nofbytes::Int
      arrdims::Vector{Int}
      numtype::String
      kwarg_name::String
      category::String
   end

   bindescr() = bindescr(1,0,[],"", "", "numarrays")

   global b1 = bindescr(3,3,[],"Int16", "testarg", "numarrays")
   global b2 = bindescr()
end
