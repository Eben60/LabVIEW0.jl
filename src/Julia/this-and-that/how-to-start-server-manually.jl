using LV_ZMQ_Jl
include(get_script_path(raw"C:\_LabView_projects\ZMQ\LV_ZMQ_Jl.jl\src\Julia\Examples-UserFn.jl"));
setglobals(isOK=true, extant=true);
ZMQ_server(fns);
