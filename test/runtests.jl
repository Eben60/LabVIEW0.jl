using Labview2Jl
using Test

@testset "Labview2Jl.jl" begin
    # Write your tests here.

    # Here are the tests:
    @test Labview2Jl.tmp_test(0) == 0
    @test Labview2Jl.tmp_test(3) == 3
    @test Labview2Jl.tmp_test(5) == 5
end
