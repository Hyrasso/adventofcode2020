function get_trees(file)
    lines = readlines(file)
    res = [e == '#' for line in map(collect, lines) for e in line]
    res = reshape(res, length(lines[1]), length(lines))'
    res
end

function solve(trees, slope=(1, 3))
    forest_size = size(trees)
    pos = [0, 0]
    total = 0
    while pos[1] < forest_size[1]
        # @show pos
        total += trees[(pos .% forest_size .+ 1)...]
        pos .+= slope
    end
    return total
end

function solve2(trees)
    r = map(slope -> solve(trees, slope), [
        (1, 1),
        (1, 3),
        (1, 5),
        (1, 7),
        (2, 1)
    ])
    # println(r)
    foldl(*, r)
end

open("inputs/03-test.txt") do file
    trees = get_trees(file)
    @assert solve(trees) == 7
    @assert solve2(trees) == 336
end

open("inputs/03.txt") do file
    trees = get_trees(file)
    println("Part 1 : $(solve(trees))")
    println("Part 2 : $(solve2(trees))")
end