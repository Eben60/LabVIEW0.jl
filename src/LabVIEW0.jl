module LabVIEW0

"""
    lv_dir()

Locate the LabVIEW folder within the project
"""
function lv_dir()
    lv_path = @__DIR__
    println(lv_path)
    return lv_path
end
export lv_dir

using Reexport
@reexport using LVServer

end
