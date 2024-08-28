"""
    free_energy!(model, config)

Compute the free energy of the SCFT polymer model. The chemical potential is also returned.

Only applicable to two-chain two-component system, e.g. AB/A, AB3/A etc.
"""
function free_energy!(model, config)
    cellopt = uppercase(config["Algorithm_Cell_Optimization"]["algorithm"])
    if cellopt == "SINGLE"
        F = run!(model, config)
    elseif cellopt == "BRENT" || cellopt == "AUTO"
        res = optimize_cell!(model, config)
        config["Algorithm_Cell_Optimization"]["cell_guess"][1] = Optim.minimizer(res)
        # F = minimum(res)
    end

    return CppPolyorder.H(model)+CppPolyorder.Hi(model), CppPolyorder.mu(model)
end

"""
    grand_potential(ϕ₁, ϕ₂, ϕ₀, model1, config1; model2=nothing, config2=nothing)

Compute the grand potential and its first order derivatives. Note the same polymer model is assumed is for model1 and model2 but for different phases and chain volume fractions. If model2 and config2 are also specified. Theire consistency with model1 and config1 is not checked! Please make sure they describe the same polymer model!

Only applicable to two-chain two-component system, e.g. AB/A, AB3/A etc.

This method is deprecated and replaced by PhaseDiagram.jl: gibbs_free_energy.
"""
function grand_potential(ϕ₁, ϕ₂, ϕ₀, model1, config1; model2=nothing, config2=nothing)
    if model2 === nothing
        model2 = model1
    end
    if config2 === nothing
        config2 = config1
    end
    v₁ = (ϕ₀ - ϕ₂) / (ϕ₁ - ϕ₂)
    v₂ = 1 - v₁
    config1["Model"]["phi"][1] = 1 - ϕ₁
    config1["Model"]["phi"][2] = ϕ₁
    F₁, μ₁ = free_energy!(model1, config1)
    config2["Model"]["phi"][1] = 1 - ϕ₂
    config2["Model"]["phi"][2] = ϕ₂
    F₂, μ₂ = free_energy!(model2, config2)
    G = v₁ * F₁ + v₂ * F₂
    fs = config1["Model"]["f"]
    α = fs[1] * fs[end]
    dG1 = v₁ * (F₂ - F₁) / (ϕ₁ - ϕ₂) + v₁ * μ₁ / α
    dG2 = v₂ * (F₂ - F₁) / (ϕ₁ - ϕ₂) + v₂ * μ₂ / α
    return G, dG1, dG2
end