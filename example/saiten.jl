# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:hydrogen
#     text_representation:
#       extension: .jl
#       format_name: hydrogen
#       format_version: '1.3'
#       jupytext_version: 1.10.3
#   kernelspec:
#     display_name: Julia 1.7.3
#     language: julia
#     name: julia-1.7
# ---

# %%
using Saiten
using PrettyPrinting
using Printf

# %%
sol_str = """
[1]
a = [1, 10]
b = [2, 10]

[2]
c = [[3, 4], 10]
"""
sol = TOML.parse(sol_str)
pprint(sol)

# %%
ans1_str = """
[0]
name = "愛上夫"
id = "A0BC00001"

[1]
a = 1
b = 2

[2]
c = [3, 4]
"""

ans2_str = """
[0]
name = "加木久家子"
id = "A0BC00002"

[1]
a = 1
b = 2.5

[2]
c = [3, 4]
"""

ans3_str = ""

ans4_str = """
[0]
name = "佐子巣瀬祖"
id = "A0BC00003"

[1]
b = 2

[2]
"""

ans_strs = [
    ans1_str
    ans2_str
    ans3_str
    ans4_str
]

# %%
grep(r) = A -> filter(s -> occursin(r, s), A)
subdirs = readdir(".") |> grep(r"^サブ")

# %%
for (k, d) in enumerate(subdirs)
    num = @sprintf "%04d" k
    fn = joinpath(d, "kaito$num.toml")
    ans_str = ans_strs[k]
    if !isempty(ans_str)
        write(fn, ans_str)
        println(fn)
    end
end

# %%
zentensu = []
for (k ,d) in enumerate(subdirs)
    tn_ans_vec = readdir(d) |> grep(r"^kaito.*\.toml")
    if isempty(tn_ans_vec)
        num = @sprintf "%04d" k
        fn_ans = joinpath(d, "kaito$num.toml")
        ans = Dict()
    else
        tn_ans = first(tn_ans_vec)
        fn_ans = joinpath(d, tn_ans)
        ans = TOML.parsefile(fn_ans)
        @show fn_ans 
    end
    
    kekka, gokeiten = saiten(ans, sol)
    header = get(kekka, "0", Dict())
    name = get(header, "name", "")
    id = get(header, "id", "")
    tn_kekka = "kekka_" * name * "_" * id * "_" * replace(fn_ans, r"^.*kaito"=>"")
    @show tn_kekka
    fn_kekka = joinpath(d, tn_kekka)
    kekka_str = sprint(kekka) do io, x; TOML.print(io, x; sorted=true) end
    println(kekka_str)
    write(fn_kekka, kekka_str)
    @show fn_kekka
    push!(zentensu, replace(tn_kekka, r".toml$"=>"") => gokeiten)
    
    pprintln(ans)
    pprintln(kekka)
    @show gokeiten
    println("-"^78)
end

# %%
write("zentensu.txt", join(string.(zentensu), "\n"))

# %%
print(read("zentensu.txt", String))

# %%
