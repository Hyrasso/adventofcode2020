function solve(numbers; total=2020)
    sort!(numbers)
    for (i, start) in enumerate(numbers)
        r = searchsorted(numbers[i+1:end], total - start)
        if r.start <= r.stop
            return start * numbers[r.start + i]
        end
    end
end

function solve2(numbers)
    sort!(numbers)
    for (i, start) in enumerate(numbers)
        r = solve(numbers[i+1:end], total=2020 - start)
        if r !== nothing
            return r * start
        end
    end
end

@assert solve([1721,979,366,299,675,1456]) == 514579
@assert solve2([1721,979,366,299,675,1456]) == 241861950

open("inputs/01-1.txt") do file
    lines = readlines(file)
    numbers = map(x -> parse(Int32,x), lines)
    println("Part 1: $(solve(numbers))")
    println("Part 2: $(solve2(numbers))")
end