module MyPkgTemplates

using PkgTemplates

include(joinpath("plugin", "TestsInSrc.jl"))
include(joinpath("plugin", "AllRightsReserved.jl"))

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

private(; host, owner, kwargs...) = Template(;
    host=host,
    ssh=true,
    license="",
    plugins=[
        TestsInSrc(),
        AllRightsReserved(owner),
    ],
    kwargs...
)

end # module
