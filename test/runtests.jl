using CppPolyorder
using YAML
using CxxWrap
using Test

@testset "Config" begin
    config_file = "./DIS.yml"
    config = CppPolyorder.parse_config(config_file)

    @test config["Version"]["version"] == 11.1
    @test config["Model"]["n_block"] == [4, 1]
    @test config["IO"]["is_display"] == true
end

@testset "Model" begin
    config_file = "./DIS.yml"
    model, config = CppPolyorder.init_model(config_file)

    model_alias = model
    @test model_alias === model

    @test CppPolyorder.Hi(model) ≈ -0.7641464471205148 atol=1e-6
    @test CppPolyorder.run!(model, config) ≈ 3.6134535528794847 atol=1e-6

    F, mu = CppPolyorder.free_energy!(model, config)
    @test F ≈ 3.6134535528794847 atol=1e-6
    @test mu ≈ 0.6744577118259163 atol=1e-6
end
