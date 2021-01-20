using LabView0mqJl

try
   # include(get_script_path(raw"C:\_LabView_projects\ZMQ\LabView0mqJl.jl\src\Julia\this-and-that\test_user_broken-file.jl"))
   include(get_script_path(raw"C:\_LabView_projects\ZMQ\LabView0mqJl.jl\src\Julia\this-and-that\test_user_f.jl"))
   LabView0mqJl.setglobals(isOK=true)
   # println("here OK")
catch excep
   # @show excep
   # println("there not OK")
   LabView0mqJl.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
   # global scriptOK = false
   # global scriptexcep = (;excep, stack_trace=backtrace())
   # println(scriptexcep.excep)
end

# @show LabView0mqJl.scriptOK, scriptexists #, scriptexcep
server_0mq4lv(fns)
