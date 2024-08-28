using CppPolyorder
using Documenter

makedocs(;
    modules=[CppPolyorder],
    authors="Yi-Xin Liu <lyx@fudan.edu.cn> and contributors",
    repo="https://github.com/liuyxpp/CppPolyorder.jl/blob/{commit}{path}#L{line}",
    sitename="CppPolyorder.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://liuyxpp.github.io/CppPolyorder.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/liuyxpp/CppPolyorder.jl",
)
