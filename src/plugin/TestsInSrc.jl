using AutoHashEquals
import PkgTemplates
using PkgTemplates: CustomPlugin, gen_file

@auto_hash_equals struct TestsInSrc <: CustomPlugin
    gitignore::Vector{AbstractString}

    TestsInSrc() = new([])

    function PkgTemplates.gen_plugin(p::TestsInSrc, t::Template, pkg_name::AbstractString)
        loop_text = """
            using $pkg_name
            using Test

            @testset "$pkg_name.jl" begin
                for (root, dirs, files) in walkdir("../src")
                    for file in files
                        if endswith(file, ".jl") && startswith(file, "test_")
                            include(joinpath(root, file))
                        end
                    end
                end
            end
            """

        gen_file(joinpath(t.dir, pkg_name, "test", "runtests.jl"), loop_text)

        test_text = """
            using $pkg_name
            using Test

            @test $pkg_name.greet() == nothing
            """

        gen_file(joinpath(t.dir, pkg_name, "src", "test_$pkg_name.jl"), test_text)
        ["runtests.jl", "test_$pkg_name.jl"]
    end
end

PkgTemplates.interactive(::Type{TestsInSrc}) = TestsInSrc()
