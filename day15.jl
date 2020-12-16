function solve(numbers, step)
    p = Dict(n => i for (i, n) in enumerate(numbers[1:end-1]))
    ln = numbers[end]
    for i in length(numbers)+1:step
        previ = get(p, ln, nothing)
        if previ !== nothing
            nn = i - previ - 1
        else
            nn = 0
        end
        p[ln] = i-1
        ln = nn
    end
    @show ln
end

@assert solve([0,3,6], 4) == 0
@assert solve([0,3,6], 5) == 3
@assert solve([0,3,6], 2020) == 436
@assert solve([3,1,2], 2020) == 1836

@assert solve([0,3,6], 30000000) == 175594

println("Part 1: $(solve([0,12,6,13,20,1,17], 2020))")
println("Part 2: $(solve([0,12,6,13,20,1,17], 30000000))")