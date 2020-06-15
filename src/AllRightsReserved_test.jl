using Test
using MyPkgTemplates

@testset "AllRightsReserved" begin
    @test isfile(AllRightsReserved.TEMPLATE_PATH)
end
