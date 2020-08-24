using Polyorder
using Documenter

makedocs(;
    modules=[Polyorder],
    authors="Yi-Xin Liu <lyx@fudan.edu.cn> and contributors",
    repo="https://github.com/liuyxpp/Polyorder.jl/blob/{commit}{path}#L{line}",
    sitename="Polyorder.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://liuyxpp.github.io/Polyorder.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/liuyxpp/Polyorder.jl",
)
