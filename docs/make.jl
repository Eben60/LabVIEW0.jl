push!(LOAD_PATH,"../src/")

using LabVIEW0
using Documenter

makedocs(
    sitename = "LabVIEW0.jl",
    modules  = [LabVIEW0],
    pages=[
       "Home" => "index.md",
       "Installation and Getting Started" => "installation_advice.md",
       "Julia scripts for use with LabVIEW" => "writing_Julia_scripts.md",
       "Examples" => "example_descriptions.md",
      ])

deploydocs(;
    repo="https://github.com/Eben60/LabVIEW0.jl",
    )
