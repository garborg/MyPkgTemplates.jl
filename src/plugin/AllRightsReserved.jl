import PkgTemplates: CustomPlugin, gen_file, gen_plugin, interactive, substitute
using AutoHashEquals

@auto_hash_equals struct AllRightsReserved <: CustomPlugin
    gitignore::Vector{AbstractString}
    owner::AbstractString

    AllRightsReserved(owner) = new([], owner)

    function gen_plugin(p::AllRightsReserved, t::Template, pkg_name::AbstractString)
        lic_template = """
            Copyright {{YEAR}} by {{OWNER}}. All rights reserved.
            """
        lic_text = substitute(lic_template, t, view = Dict{String,Any}("PKGNAME" => pkg_name))
        gen_file(joinpath(t.dir, pkg_name, "test", "runtests.jl"), loop_text)

        test_template = """
            using {{PKGNAME}}
            using Test

            @test {{PKGNAME}}.greet() == nothing
            """
        test_text = substitute(test_template, t, view = Dict{String,Any}("PKGNAME" => pkg_name))
        gen_file(joinpath(t.dir, pkg_name, "src", "test_$pkg_name.jl"), test_text)
        ["runtests.jl", "test_$pkg_name.jl"]
    end
end

interactive(::Type{AllRightsReserved}) = AllRightsReserved()
