function get_actions(lines)
    [(Symbol(l[1]), parse(Int, l[2:end])) for l in lines]
end

function solve(actions)
    pos = [0, 0]
    directions = [:E, :S, :W, :N]
    move = [[1,0], [0,-1], [-1,0], [0,1]]
    dir = 1
    for (a, dist) in actions
        if a == :F
            pos += move[dir] .* dist
        elseif a == :R
            dir = mod1(dir+(dist ÷ 90), 4)
        elseif a == :L
            dir = mod1(dir-(dist ÷ 90), 4)
        elseif a in directions
            pos += move[findfirst(==(a), directions)] .* dist
        else
            @error (a, dist)
        end
    end
    sum(abs.(pos))
end

function solve2(actions)
    pos = [0, 0]'
    waypoint = [10, 1]'
    directions = [:E, :S, :W, :N]
    move = adjoint.([[1,0], [0,-1], [-1,0], [0,1]])
    for (a, dist) in actions
        if a == :F
            pos += waypoint .* dist
        elseif a == :L
            waypoint = waypoint * [0 1;-1 0] ^ (dist÷90)
        elseif a == :R
            waypoint = waypoint * [0 -1;1 0] ^ (dist÷90)
        elseif a in directions
            waypoint += move[findfirst(==(a), directions)] .* dist
        else
            @error (a, dist)
        end
        # @show (a, dist), pos, waypoint
    end
    sum(abs.(pos))
end

test_input = IOBuffer("""F10
N3
F7
R90
F11""")

test_actions = get_actions(readlines(test_input))
@assert solve(test_actions) == 25
@assert solve2(test_actions) == 286

open("inputs/12.txt") do file
    actions = get_actions(readlines(file))
    println("Part 1: $(solve(actions))")
    println("Part 2: $(solve2(actions))")
end