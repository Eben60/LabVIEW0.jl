using JSON3
const jss = """{"fun_name":"myfc","str_arg":"str_arg","Byte_array":[21,56,19,37,55,89,74,38,49,90,2,10,96,88,14,76]}"""

function myfc(;str_arg="", Byte_array=[])
   (str=str_arg, bytes = Byte_array)
end

function parse_lv_json_req(jsn)
   ob=JSON3.read(jsn)
   fun = eval(Symbol(ob.fun_name))
   qa = Dict{Symbol, Any}(ob)
   pop!(qa, :fun_name)
   (fun=fun, qa=qa)
end

function callwhatLVasked(p)
   p.fun(; p.qa...)
end
