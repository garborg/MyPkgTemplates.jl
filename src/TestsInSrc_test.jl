using Test
using MyPkgTemplates

@testset "TestsInSrc" begin
    @test isfile(TestsInSrc.TEMPLATE_PATH)
end
