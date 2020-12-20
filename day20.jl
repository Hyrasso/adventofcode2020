
function get_tiles(lines)
    tidx = findall(==(0) ∘ length, lines)
    s = tidx[1] - 2
    push!(tidx, 0)
    tiles = Dict()
    for idx in tidx
        tn = parse(Int, split(lines[idx+1])[2][1:end-1])
        tile = permutedims(hcat(collect.(lines[idx+2:idx+1+s])...), (2,1))
        borders = [
            max(tile[:  , 1  ] .== '#', tile[end:-1:1, 1       ] .== '#'),
            max(tile[:  , end] .== '#', tile[end:-1:1, end     ] .== '#'),
            max(tile[1  , :  ] .== '#', tile[1       , end:-1:1] .== '#'),
            max(tile[end, :  ] .== '#', tile[end     , end:-1:1] .== '#'),
        ]
        borders = map(b -> b.chunks[1], borders)
        tiles[tn] = borders
    end
    tiles
end

function solve(tiles)
    all_borders = Base.Iterators.flatten(values(tiles))
    has_neighbor(b, bs) = count(==(b), bs) > 1
    r = 1
    for (tid, borders) in tiles
        if sum(has_neighbor(border, all_borders) for border in borders) == 2
            # @show tid
            r *= tid
        end
    end
    r
end

open("inputs/20-test.txt") do file
    test_tiles = get_tiles(readlines(file))
    @assert solve(test_tiles) == 20899048083289
end

open("inputs/20.txt") do file
    tiles = get_tiles(readlines(file))
    println("Part 1: $(solve(tiles))")
end