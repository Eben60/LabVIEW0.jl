using Labview2Jl

try
    include(get_script_path(raw"C:\_LabView_projects\ZMQ\Labview2Jl.jl\src\LabVIEW\jl-scripts\simple_examples.jl"))
    Labview2Jl.setglobals(isOK=true)
catch excep
    Labview2Jl.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
end

server_0mq4lv(fns)
