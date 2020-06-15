using Test
using {{{PKG}}}

@testset "{{{PKG}}}.jl" begin
    for (root, _, files) in walkdir("../src")
        for file in files
            if endswith(file, "_test.jl")
                include(joinpath(root, file))
            end
        end
    end
end

