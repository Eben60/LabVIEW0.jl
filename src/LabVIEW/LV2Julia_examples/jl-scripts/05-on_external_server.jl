"""
This script is to be used with the example ´05c-multifunc_external-server.vi´ to start
the corresponding Julia script on remote server:

- Install ´LabVIEW0´ on that computer
- Adapt the path below to point to the example script ´05-multiple_functions.jl´
- In the Terminal window, type ´Julia [path to this script]´
- Run ´05c-multifunc_external-server.vi´ on the LabVIEW computer
"""

using LabVIEW0

try
   # change the path!
   include(get_script_path(raw"C:\_MyOwnDocs\SoftwareDevelopment\LabVIEW0.jl\src\LabVIEW\LV2Julia_examples\jl-scripts\05-multiple_functions.jl"))
   LabVIEW0.setglobals(isOK=true)
catch excep
  LabVIEW0.setglobals(isOK=false, excpn=(;excep, stack_trace=backtrace()))
end

server_0mq4lv(fns)
