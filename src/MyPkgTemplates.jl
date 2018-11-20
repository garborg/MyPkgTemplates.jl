module MyPkgTemplates

using PkgTemplates

include("plugin/TestsInSrc.jl")
include("plugin/AllRightsReserved.jl")

# [documenter key instructions](https://github.com/invenia/PkgTemplates.jl/issues/15)
public(; kwargs...) = Template(;
    ssh=true,
    plugins=[
        TravisCI(),
        Codecov(),
        Coveralls(),
        GitHubPages(),
        TestsInSrc(),
    ],
    kwargs...
)

private(; owner, kwargs...) = Template(;
    ssh=true,
    plugins=[
        TestsInSrc(),
        AllRightsReserved(owner),
    ],
    kwargs...
)

end # module
