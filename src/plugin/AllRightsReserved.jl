using Dates: today, year

using AutoHashEquals
import PkgTemplates
using PkgTemplates: CustomPlugin, gen_file

@auto_hash_equals struct AllRightsReserved <: CustomPlugin
    gitignore::Vector{AbstractString}
    owner::AbstractString

    AllRightsReserved(owner) = new([], owner)

    function PkgTemplates.gen_plugin(p::AllRightsReserved, t::Template, pkg_name::AbstractString)
        lic_text = "Copyright (c) $(year(today())) $(p.owner). All rights reserved."
        gen_file(joinpath(t.dir, pkg_name, "LICENSE"), lic_text)

        ["LICENSE"]
    end
end

PkgTemplates.interactive(::Type{AllRightsReserved}) = AllRightsReserved()
