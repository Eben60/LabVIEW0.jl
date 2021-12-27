using LabView0mqJl

try
    include(get_script_path(raw"C:\_LabView_projects\ZMQ\LabView0mqJl.jl\src\LabVIEW\jl-scripts\simple_examples.jl"))
    LabView0mqJl.setglobals(isOK=true)
catch excep
    LabView0mqJl.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
end

server_0mq4lv(fns)
