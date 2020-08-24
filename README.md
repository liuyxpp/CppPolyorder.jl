# Polyorder [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://liuyxpp.github.io/Polyorder.jl/stable) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://liuyxpp.github.io/Polyorder.jl/dev) [![Build Status](https://github.com/liuyxpp/Polyorder.jl/workflows/CI/badge.svg)](https://github.com/liuyxpp/Polyorder.jl/actions) [![Build Status](https://travis-ci.com/liuyxpp/Polyorder.jl.svg?branch=master)](https://travis-ci.com/liuyxpp/Polyorder.jl) [![Build Status](https://ci.appveyor.com/api/projects/status/github/liuyxpp/Polyorder.jl?svg=true)](https://ci.appveyor.com/project/liuyxpp/Polyorder-jl) [![Coverage](https://codecov.io/gh/liuyxpp/Polyorder.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/liuyxpp/Polyorder.jl)

This package provides an interface to essential functionalities of C++ [Polyorder](https://github.com/liuyxpp/polyorder) library.

## Install

In Julia REPL, press `]` to enter the Package mode, then run the following command.

```
(v1.5) pkg> add https://github.com/liuyxpp/Polyorder.jl
```

## Interface

### Objects

```julia
Config
Model
Model_AB
Model_AB_A
Model_AB3_A
```

### Functions from C++ Polyorder library

```julia
H
Hi  # only for Model_AB_A and Model_AB3_A
Hs
Hw
Qc  # only for Model_AB_A and Model_AB3_A
Qh  # only for Model_AB_A and Model_AB3_A
display
display_parameters
get_config_data  # for Config
incomp
init
mu  # only for Model_AB_A and Model_AB3_A
muc  # only for Model_AB_A and Model_AB3_A
muh  # only for Model_AB_A and Model_AB3_A
reset
residual_error
save
save_density
save_field
save_mode
save_q
set_config_data  # for Config
update
version  # for Config
```

### Utility functions

```julia
parse_config
init_model
reset_model!
run!
scft
brent_init
optimize_cell!
free_energy!
grand_potential
```

## Links

- [Documentation](https://liuyxpp.github.io/Polyorder.jl)