module Labview2Jl

function lv_dir()
    lv_path = @__DIR__
    @show lv_path
    return path
end
export lv_dir

using Reexport
@reexport using Jl_0mq_4Labview

end
