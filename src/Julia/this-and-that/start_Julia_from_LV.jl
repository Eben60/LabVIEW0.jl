using LV_ZMQ_Jl

try
   # include(get_script_path(raw"C:\_LabView_projects\ZMQ\LV_ZMQ_Jl.jl\src\Julia\this-and-that\test_user_broken-file.jl"))
   include(get_script_path(raw"C:\_LabView_projects\ZMQ\LV_ZMQ_Jl.jl\src\Julia\this-and-that\test_user_f.jl"))
   LV_ZMQ_Jl.setglobals(isOK=true)
   # println("here OK")
catch excep
   # @show excep
   # println("there not OK")
   LV_ZMQ_Jl.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
   # global scriptOK = false
   # global scriptexcep = (;excep, stack_trace=backtrace())
   # println(scriptexcep.excep)
end

# @show LV_ZMQ_Jl.scriptOK, scriptexists #, scriptexcep
server_0mq4lv(fns)
