module Saiten

export TOML, make_kaitoyoshi, make_mohankaito, saiten

using TOML
using Unicode

relerr(x, y) = Inf
relerr(x::Integer, y::Integer) = abs(x - y)
relerr(x::Real, y::Real) = abs(x/y - 1)
relerr(x::Vector, y::Vector) = maximum(relerr(x[i], y[i]) for i in eachindex(y))
relerr(x::AbstractString, y::AbstractString) =
    Unicode.normalize(x; casefold=true) != Unicode.normalize(y; casefold=true)
nearlyequal(x, y; reltol = 0.005) = relerr(x, y) ≤ reltol

kukaito(x) = ""
kukaito(x::Dict) = Dict()
kukaito(x::AbstractFloat) = NaN

function saiten(ans, sol::Vector, gokeiten = 0)
    score = nearlyequal(ans, sol[1]) * sol[2]
    Union{typeof(ans), typeof(score)}[ans, score], gokeiten + score
end

function saiten(ans::Dict, sol::Dict, gokeiten = 0)
    kekka = Dict()
    header = get(ans, "0", nothing)
    if !isnothing(header)
        kekka["0"] = header
    end
    for k in keys(sol)
        v, gokeiten = saiten(get(ans, k, kukaito(sol[k])), sol[k], gokeiten)
        kekka[k] = v
    end
    kekka, gokeiten
end

gijikaito(x::AbstractFloat) = 46.49373
gijikaito(x::Integer) = 4649373
gijikaito(x::AbstractString) = "yes or no"
gijikaito(x::Vector) = [gijikaito(x) for x in x]

make_kaitoyoshi(sol::Vector; gijikaitofunc=gijikaito) = gijikaitofunc(sol[1])

function make_kaitoyoshi(sol::Dict; gijikaitofunc=gijikaito)
    kaitoyoshi = Dict()
    for k in keys(sol)
        v = make_kaitoyoshi(sol[k]; gijikaitofunc)
        kaitoyoshi[k] = v
    end
    kaitoyoshi
end

make_mohankaito(sol::Dict) = make_kaitoyoshi(sol; gijikaitofunc=identity)

end
