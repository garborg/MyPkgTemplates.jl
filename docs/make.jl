using Documenter, MyPkgTemplates

makedocs(;
    modules=[MyPkgTemplates],
    format=:html,
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/garborg/MyPkgTemplates.jl/blob/{commit}{path}#L{line}",
    sitename="MyPkgTemplates.jl",
    authors="Sean Garborg",
    assets=[],
)

deploydocs(;
    repo="github.com/garborg/MyPkgTemplates.jl",
    target="build",
    julia="1.0",
    deps=nothing,
    make=nothing,
)
