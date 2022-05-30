using Saiten
using Test

sol_str = """
[1]
x = [123.4, 10]
y = ["yes", 10]
z = [[34.5, 199.5], 20]
w = [999, 10]

[2]
a = [678, 10]
b = [1003, 10]

[3]
c = [[123.4, 234.5], 20]
d = ["No", 10]
"""
sol = TOML.parse(sol_str)

mohankaito = """
[1]
w = 999
x = 123.4
y = "yes"
z = [34.5, 199.5]

[2]
a = 678
b = 1003

[3]
c = [123.4, 234.5]
d = "No"
"""

kaitoyoshi = """
[1]
w = 4649373
x = 46.49373
y = "yes or no"
z = [46.49373, 46.49373]

[2]
a = 4649373
b = 4649373

[3]
c = [46.49373, 46.49373]
d = "yes or no"
"""

ans1_str = """
[0]
name = "山田太郎"
id = "A9BC99999"

[1]
w = 999
x = 123.4
z = [34.5, 199.5]
y = "yes"

[2]
a = 678
b = 1003

[3]
c = [123.4, 234.5]
d = "No"
"""
ans1 = TOML.parse(ans1_str)
kekka1, saitenkekka1 = saiten(TOML.parse(ans1_str), sol)

ans2_str = """
[0]
name = "山田太郎"
id = "A9BC99999"

[1]
w = 990
x = 123.4
y = "Yes"

[3]
c = [124.4, 234.5]
d = "no"
"""
ans2 = TOML.parse(ans2_str)
kekka2, saitenkekka2 = saiten(TOML.parse(ans2_str), sol)

@testset "Saiten.jl" begin
    @test sprint((io, x) -> TOML.print(io, x; sorted=true), make_mohankaito(sol)) == mohankaito
    @test sprint((io, x) -> TOML.print(io, x; sorted=true), make_kaitoyoshi(sol)) == kaitoyoshi
    @test saitenkekka1 == 100
    @test kekka1 == Dict("1" => Dict("w" => [999, 10],
                 "x" => [123.4, 10],
                 "z" => [[34.5, 199.5], 20],
                 "y" => ["yes", 10]),
     "0" => Dict("name" => "山田太郎", "id" => "A9BC99999"),
     "2" => Dict("b" => [1003, 10], "a" => [678, 10]),
     "3" => Dict("c" => [[123.4, 234.5], 20], "d" => ["No", 10]))
    @test saitenkekka2 ==  30
    @test kekka2 == Dict("1" => Dict("w" => [990, 0],
                 "x" => [123.4, 10],
                 "z" => ["", 0],
                 "y" => ["Yes", 10]),
     "0" => Dict("name" => "山田太郎", "id" => "A9BC99999"),
     "2" => Dict("b" => ["", 0], "a" => ["", 0]),
     "3" => Dict("c" => [[124.4, 234.5], 0], "d" => ["no", 10]))
end
