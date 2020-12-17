function parse_grid(lines, dimensions=3)
    state = Set()
    for (i, l) in enumerate(lines), (j, c) in enumerate(l)
        if c == '#'
            push!(state, ifelse(dimensions == 3, (i, j, 0), (i, j, 0, 0)))
        end
    end
    state
end

function get_neighbors(pos::NTuple{3})
    x, y, z = pos
    res = Set((x+i, y+j, z+k) for i=-1:1, j=-1:1, k=-1:1)
    delete!(res, (x, y, z))
end
function get_neighbors(pos::NTuple{4})
    x, y, z, w = pos
    res = Set((x+i, y+j, z+k, w+l) for i=-1:1, j=-1:1, k=-1:1, l=-1:1)
    delete!(res, (x, y, z, w))
end
@assert length(get_neighbors((0, -1, 2))) == 26
@assert length(get_neighbors((0, 4, 1, 0))) == 80

function solve(state, steps)
    for i in 1:steps
        count_neighbors(s, state) = sum(n in state for n in get_neighbors(s))
        nstate = Set()
        update_states = reduce(union, get_neighbors.(state))
        for s in update_states
            if s in state && count_neighbors(s, state) in (2, 3)
                push!(nstate, s)
            end
            if !(s in state) && count_neighbors(s, state) == 3
                push!(nstate, s)
            end
        end
        state = nstate
    end
    length(state)
end

test_input = IOBuffer(""".#.
..#
###""")
test_state = parse_grid(readlines(test_input))
@assert length(test_state) == 5
@assert solve(test_state, 6) == 112

test_input = IOBuffer(""".#.
..#
###""")
test_state = parse_grid(readlines(test_input), 4)
@assert length(test_state) == 5
@assert solve(test_state, 6) == 848

open("inputs/17.txt") do file
    lines = readlines(file)
    state3 = lines |> parse_grid
    println("Part 1: $(solve(state3, 6))")
    state4 = parse_grid(lines, 4)
    println("Part 2: $(solve(state4, 6))")
end