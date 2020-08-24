module Polyorder

using CxxWrap
using YAML
using Optim

if Sys.isapple()
    @wrapmodule(joinpath(@__DIR__, "../lib/libpolyorderjl.dylib"))
elseif Sys.islinux()
    # @wrapmodule(joinpath(@__DIR__, "../lib/libpolyorderjl.so"))
    error("Linux is currently not supported by Polyorder. Loading library failed!")
elseif Sys.iswindows()
    # @wrapmodule(joinpath(@__DIR__, "../lib/libpolyorderjl.dll"))
    error("Windows is currently not supported by Polyorder. Loading library failed!")
else
    error("OS is not supported by Polyorder. Loading library failed!")
end

include("common.jl")
include("chain2component2.jl")

function __init__()
    @initcxx
end

end