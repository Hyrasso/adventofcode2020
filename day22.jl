
function get_deck(lines)
    p = findfirst(==("Player 2:"), lines)
    deck1 = parse.(Int, lines[2:p-2])
    deck2 = parse.(Int, lines[p+1:end])
    deck1, deck2
end

decks = get_deck(readlines(IOBuffer("""Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10""")))

function solve(decks)
    deck1, deck2 = deepcopy(decks)
    while !isempty(deck1) && !isempty(deck2)
        c1 = popfirst!(deck1)
        c2 = popfirst!(deck2)
        if c1 > c2
            push!(deck1, c1, c2)
        else
            push!(deck2, c2, c1)
        end
    end
    winning_deck = max(deck1, deck2)
    sum([length(winning_deck):-1:1;] .* winning_deck)
end 

@assert solve(decks) == 306

function solve2!(deck1, deck2; root=false)
    states = Set()
    while !isempty(deck1) && !isempty(deck2)
        # @info deck1, deck2
        current_state = (hash(deck1), hash(deck2))
        if current_state in states
            return 1
        end
        push!(states, current_state)
        c1 = popfirst!(deck1)
        c2 = popfirst!(deck2)
        if c1 <= length(deck1) && c2 <= length(deck2)
            if solve2!(deck1[1:c1], deck2[1:c2]) == 1
                push!(deck1, c1, c2)
            else
                push!(deck2, c2, c1)
            end
        else
            if c1 > c2
                push!(deck1, c1, c2)
            else
                push!(deck2, c2, c1)
            end
        end
    end
    if length(deck1) > 0
        return 1
    else
        return 2
    end
end

function solve2(decks)
    winner = solve2!(decks...)
    winning_deck = decks[winner]
    sum([length(winning_deck):-1:1;] .* winning_deck)
end

test_decks = get_deck(readlines(IOBuffer("""
Player 1:
43
19

Player 2:
2
29
14""")))

@assert solve2(test_decks) == 43 * 2 + 19 * 1
@assert solve2(([9, 2, 6, 3, 1], [5, 8, 4, 7, 10])) == 291

open("inputs/22.txt") do file
    decks = get_deck(readlines(file))
    println("Part 1: $(solve(decks))")
    println("Part 2: $(solve2(decks))")
end