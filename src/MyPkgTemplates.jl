module MyPkgTemplates

using PkgTemplates: generate

export AllRightsReserved, TestsInSrc, generate, template

include("AllRightsReserved.jl")
include("TestsInSrc.jl")

include("MyTemplate.jl")
using .MyTemplate: template

end # module
