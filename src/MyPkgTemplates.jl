module MyPkgTemplates

using PkgTemplates: generate

export FlexibleLicense, TestsInSrc, generate, template

include("plugins/FlexibleLicenses.jl")
import .FlexibleLicenses: FlexibleLicense

include("TestsInSrc.jl")
import .TestsInSrc

include("MyTemplate.jl")
using .MyTemplate: template, pkg, app, scratch

end # module
