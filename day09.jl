
function solve(numbers::Array{Int64,1}, nprevious)
    sumpair = zeros(Int64, nprevious, nprevious)
    for (i, a) in enumerate(numbers[1:nprevious]), (j, b) in enumerate(numbers[1:nprevious])
        sumpair[i, j] = a + b
    end
    for (i, n) in enumerate(numbers[nprevious+1:end])
        if !(n in sumpair)
            return n
        end
        sums = numbers[i:i+nprevious-1] .+ n
        idx = mod1(i, nprevious)
        sums = circshift(sums, idx)
        sumpair[idx, :] = sums
        sumpair[:, idx] = sums
    end
end

function solve2(numbers, nprevious)
    ew = solve(numbers, nprevious)
    csum = cumsum(numbers)
    for (i, n) in enumerate(numbers)
        if n == ew
            continue
        end
        icsum = csum[i:end] .- (i != 1 ? csum[i-1] : 0)
        stop = searchsortedfirst(icsum, ew)
        if stop <= length(icsum) && icsum[stop] == ew
            return sum(extrema(numbers[i:i+stop-1]))
        end
    end
end

@assert solve([35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576], 5) == 127

@assert solve2([35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576], 5) == 62

open("inputs/09.txt") do file
    numbers = map(i -> parse(Int64, i), readlines(file))
    println("Part 1: $(solve(numbers, 25))")
    println("Part 2: $(solve2(numbers, 25))")
end