module FlexibleLicenses

using Dates
import PkgTemplates: FilePlugin, Template, customizable, default_file, defaultkw, destination, prompt, source, view

"""
    default_format_year(2021)

Omitting year is gaining popularity (e.g. Facebook),
but I believe it breaks some license identification tools.
"""
default_format_year(y) = "$y-present"

# TODO: Make FlexibleLicense [customizable](https://juliaci.github.io/PkgTemplates.jl/stable/developer/#Supporting-Interactive-Mode)

"""
    OwnerFlexibleLicense(; owner="Yoyodynene, Inc.", name="MIT", path=nothing, destination="LICENSE")
Creates a license file. Provides the ability to specify an owner other than the package authors.
## Keyword Arguments
- `name::AbstractString`: Name of a license supported by PkgTemplates.
  Available licenses can be seen
  [here](https://github.com/invenia/PkgTemplates.jl/tree/master/templates/licenses).
- `path::Union{AbstractString, Nothing}`: Path to a custom license file.
  This keyword takes priority over `name`.
- `destination::AbstractString`: File destination, relative to the repository root.
  For example, `"LICENSE.md"` might be desired.
"""
struct FlexibleLicense <: FilePlugin
    path::String
    destination::String
    owner::Union{Nothing,String}
    format_year::Function
end

function FlexibleLicense(;
    name::AbstractString="MIT",
    path::Union{AbstractString, Nothing}=nothing,
    destination::AbstractString="LICENSE",
    owner::Union{Nothing,String}=nothing,
    format_year::Function=default_format_year,
)
    if path === nothing
        path = if name == "UNLICENSED"
            joinpath(@__DIR__, "..", "templates", "UNLICENSED")
        else
            default_file("licenses", name)
        end
        isfile(path) || throw(ArgumentError("FlexibleLicense '$(basename(path))' is not available"))
    end
    return FlexibleLicense(path, destination, owner, format_year)
end

defaultkw(::Type{FlexibleLicense}, ::Val{:path}) = nothing
defaultkw(::Type{FlexibleLicense}, ::Val{:name}) = "MIT"
defaultkw(::Type{FlexibleLicense}, ::Val{:destination}) = "LICENSE"
defaultkw(::Type{FlexibleLicense}, ::Val{:owner}) = nothing
defaultkw(::Type{FlexibleLicense}, ::Val{:format_year}) = default_format_year

source(p::FlexibleLicense) = p.path
destination(p::FlexibleLicense) = p.destination
view(p::FlexibleLicense, t::Template, ::AbstractString) = Dict(
    "AUTHORS" => p.owner !== nothing ? p.owner : join(t.authors, ", "),
    "YEAR" => p.format_year(year(today())),
)

function prompt(::Type{FlexibleLicense}, ::Type, ::Val{:name})
    options = readdir(default_file("licenses"))
    pushfirst!("UNLICENSED")
    # Move MIT to the top.
    deleteat!(options, findfirst(==("MIT"), options))
    pushfirst!(options, "MIT")
    menu = RadioMenu(options; pagesize=length(options))
    println("Select a license:")
    idx = request(menu)
    return options[idx]
end

customizable(::Type{FlexibleLicense}) = (:name => String,)

end # module
