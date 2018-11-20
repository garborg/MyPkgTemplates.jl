import PkgTemplates: CustomPlugin, gen_file, gen_plugin, interactive, substitute
using AutoHashEquals

@auto_hash_equals struct TestsInSrc <: CustomPlugin
    gitignore::Vector{AbstractString}

    TestsInSrc() = new([])

    function gen_plugin(p::TestsInSrc, t::Template, pkg_name::AbstractString)
        loop_template = """
            using {{PKGNAME}}
            using Test

            @testset "{{PKGNAME}}.jl" begin
                for (root, dirs, files) in walkdir("../src")
                    for file in files
                        if endswith(file, ".jl") && startswith(file, "test_")
                            include(joinpath(root, file))
                        end
                    end
                end
            end
            """
        loop_text = substitute(loop_template, t, view = Dict{String,Any}("PKGNAME" => pkg_name))
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

interactive(::Type{TestsInSrc}) = TestsInSrc()
