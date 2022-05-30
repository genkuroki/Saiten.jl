using Saiten
using Documenter

DocMeta.setdocmeta!(Saiten, :DocTestSetup, :(using Saiten); recursive=true)

makedocs(;
    modules=[Saiten],
    authors="Gen Kuroki <genkuroki@gmail.com> and contributors",
    repo="https://github.com/genkuroki/Saiten.jl/blob/{commit}{path}#{line}",
    sitename="Saiten.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://genkuroki.github.io/Saiten.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/genkuroki/Saiten.jl",
    devbranch="main",
)
