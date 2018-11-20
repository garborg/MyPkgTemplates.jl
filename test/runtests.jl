using MyPkgTemplates
using Test

@testset "MyPkgTemplates.jl" begin
    for (root, dirs, files) in walkdir("../src")
        for file in files
            if endswith(file, ".jl") && startswith(file, "test_")
                include(joinpath(root, file))
            end
        end
    end
end
