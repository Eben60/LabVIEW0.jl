using LabView0mqJl

try
    include(get_script_path(raw"/users/eben60/Desktop/Julia/LabView0mqJl.jl/src/LabVIEW/jl-scripts/09_combined_example.jl"))
    LabView0mqJl.setglobals(isOK=true)
catch excep
    LabView0mqJl.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
end

server_0mq4lv(fns)
