function solve!(adapters)
    push!(adapters, 0)
    sort!(adapters)
    push!(adapters, adapters[end] + 3)
    jdiff = diff(adapters)
    sum(jdiff .== 1) * sum(jdiff .== 3)
end

function solve2!(adapters)
    push!(adapters, 0)
    sort!(adapters)
    push!(adapters, adapters[end] + 3)
    jdiff = diff(adapters)
    # fix size of first group
    pushfirst!(jdiff, 0)
    group = cumsum(jdiff .÷ 2) # group index +1 for each 3 joutls interval, ÷2 ≈ 1 -> 0, 3 -> 1
    prod(map(gi -> [1, 1, 2, 4, 7][sum(group .== gi)], collect(Set(group))))
end

test_input = IOBuffer("""16
10
15
5
1
11
7
19
6
12
4""")

test_adapters = map(a -> parse(Int, a), readlines(test_input))

@assert solve!(test_adapters[:]) == 7 * 5
@assert solve2!(test_adapters[:]) == 8
@assert solve2!([28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3]) == 19208

open("inputs/10.txt") do file
    adapters = map(a -> parse(Int, a), readlines(file))
    println("Part 1: $(solve!(adapters[:]))")
    println("Part 2: $(solve2!(adapters[:]))")
end