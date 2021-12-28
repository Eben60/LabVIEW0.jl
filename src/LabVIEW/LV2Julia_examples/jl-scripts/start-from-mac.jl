using Labview2Jl

try
    include(get_script_path(raw"/users/eben60/Desktop/Julia/Labview2Jl.jl/src/LabVIEW/jl-scripts/09_combined_example.jl"))
    Labview2Jl.setglobals(isOK=true)
catch excep
    Labview2Jl.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
end

server_0mq4lv(fns)
