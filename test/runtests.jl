using Polyorder
using YAML
using CxxWrap
using Test

@testset "Config" begin
    config_file = "./DIS.yml"
    config = Polyorder.parse_config(config_file)

    @test config["Version"]["version"] == 11.1
    @test config["Model"]["n_block"] == [4, 1]
    @test config["IO"]["is_display"] == true
end

@testset "Model" begin
    config_file = "./DIS.yml"
    model, config = Polyorder.init_model(config_file)

    model_alias = model
    @test model_alias === model

    @test Polyorder.Hi(model) ≈ -0.7641464471205148 atol=1e-6
    @test Polyorder.run!(model, config) ≈ 3.6134535528794847 atol=1e-6

    F, mu = Polyorder.free_energy!(model, config)
    @test F ≈ 3.6134535528794847 atol=1e-6
    @test mu ≈ 0.6744577118259163 atol=1e-6
end
