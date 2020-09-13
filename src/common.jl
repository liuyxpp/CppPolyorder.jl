"""
    parse_config(config_file)

Generate a YAML.jl config object by first passing `config_file` to Polyorder to do any configuration checks for its consistency. Here ·config_file` is path string.
"""
function parse_config(config_file)
    config = Polyorder.Config(config_file)
    data = StdString()
    # @show Polyorder.version(config)
    Polyorder.get_config_data(config, CxxRef(data))
    # @show data
    config = YAML.load(String(data))

    return config
end

function init_model(config_file)
    config = parse_config(config_file)

    modeltype = config["Model"]["model"]
    if uppercase(modeltype) == "AB" || uppercase(modeltype) == "AB"
        model = Polyorder.Model_AB(config_file)
    elseif uppercase(modeltype) == "AB_A" || uppercase(modeltype) == "AB+A"
        model = Polyorder.Model_AB_A(config_file)
    elseif uppercase(modeltype) == "AB3_A" || uppercase(modeltype) == "AB3+A"
        model = Polyorder.Model_AB3_A(config_file)
    else
        error("Model $modeltype is not supported by Polyorder!")
    end

    return model, config
end

function reset_model!(model, config)
    config_str = StdString(YAML.write(config))
    Polyorder.reset(model, CxxRef(config_str))
end

function run!(model, config)
    reset_model!(model, config)
    max_iter = config["Algorithm_SCFT"]["max_iter"]
    display_interval = config["IO"]["display_interval"]
    if display_interval < 1
        display_interval = max_iter + 1
    end
    thresh_residual = config["Algorithm_SCFT"]["thresh_residual"]
    for i in 1:max_iter
        Polyorder.update(model)
        Hi = Polyorder.Hi(model)
        H = Polyorder.H(model)
        err = Polyorder.residual_error(model)
        if i % display_interval == 0
            @info "SCFT iteration: $i"
            Polyorder.display(model)
        end
        if err < thresh_residual
            return H + Hi
        end
    end
    return Inf
end

function scft(x, model, config)
    dim = config["Grid"]["dimension"]
    a = config["UnitCell"]["a"]
    config["UnitCell"]["a"] = x
    if dim == 2
        b = config["UnitCell"]["b"]
        config["UnitCell"]["b"] = (x / a) * b
    end
    if dim == 3
        c = config["UnitCell"]["c"]
        config["UnitCell"]["c"] = (x / a) * c
    end

    @info "SCFT optimize cell: a = $a"

    F = run!(model, config)

    @assert F !== Inf "SCFT cannot achieve accuray within max_iter steps!"

    return F
end

"""
brent_init(guess, interval)

Return an interval `(a, b)` which feeds to Optim.solve with Optim.Brent() and the initial value for Brent method will be `guess` and `interval = b - a`.
"""
function brent_init(guess, interval)
    r = (2 - MathConstants.golden)
    a = guess - r * interval
    b = a + interval
    if a < 1.0
        a = 1.0
        b = (guess - a) / r + a
    end

    return a, b
end

function optimize_cell!(model, config)
    guess = config["Algorithm_Cell_Optimization"]["cell_guess"][1]
    interval = config["Algorithm_Cell_Optimization"]["cell_interval"][1]
    abs_tol = config["Algorithm_Cell_Optimization"]["tol_cell"]
    store_trace = config["Algorithm_Cell_Optimization"]["store_trace"]
    show_trace = config["Algorithm_Cell_Optimization"]["show_trace"]
    lower, upper = brent_init(guess, interval)
    result = Optim.optimize(x -> scft(x, model, config), lower, upper, Optim.Brent(); abs_tol=abs_tol, store_trace=store_trace, show_trace=show_trace)

    return result
end