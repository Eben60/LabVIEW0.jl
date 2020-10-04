using Documenter, LV_ZMQ_Jl

makedocs(
    modules = [LV_ZMQ_Jl],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Eben60",
    sitename = "LV_ZMQ_Jl.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/Eben60/LV_ZMQ_Jl.jl.git",
    push_preview = true
)
