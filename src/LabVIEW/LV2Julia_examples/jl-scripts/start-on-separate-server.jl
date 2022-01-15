using LabVIEW0

try
    # change the path accordingly
    include(get_script_path(raw"/users/eben60/Desktop/Julia/LabVIEW0.jl/src/LabVIEW/jl-scripts/09_combined_example.jl"))
    LabVIEW0.setglobals(isOK=true)
catch excep
    LabVIEW0.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
end

server_0mq4lv(fns)
