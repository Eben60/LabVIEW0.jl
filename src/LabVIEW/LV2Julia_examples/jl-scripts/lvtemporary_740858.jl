using LabVIEW0

try
    include(get_script_path(raw"C:\_LabView_projects\ZMQ\LabVIEW0.jl\src\LabVIEW\jl-scripts\simple_examples.jl"))
    LabVIEW0.setglobals(isOK=true)
catch excep
    LabVIEW0.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
end

server_0mq4lv(fns)
