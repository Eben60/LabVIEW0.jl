using LabView0mqJl
using Test

@testset "LabView0mqJl.jl" begin
    # Write your tests here.

    # Here are the tests:
    @test LabView0mqJl.tmp_test(0) == 0
    @test LabView0mqJl.tmp_test(3) == 3
    @test LabView0mqJl.tmp_test(5) == 5
end
