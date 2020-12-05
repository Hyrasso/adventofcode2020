po2 = 2 .^ [9:-1:0;]

function seat(pass, as_tuple=false)
    pass = collect(pass)
    seat_id = sum(po2 .* map(c -> (c == 'B') | (c == 'R'), pass))
    as_tuple ? (seat_id >> 3, seat_id & 7) : seat_id
end

@assert seat("FBFBBFFRLR", true) == (44, 5)
@assert seat("BFFFBBFRRR", true) == (70, 7)
@assert seat("FFFBBBFRRR", true) == (14, 7)
@assert seat("BBFFBBFRLL", true) == (102, 4)

id(pass) = pass[1] * 8 + pass[2]

function solve(passes)
    ids = map(seat, passes)
    @debug ids
    maximum(ids)
end

function solve2(passes)
    ids = map(seat, passes)
    fst, lst = extrema(ids)
    seat_id = setdiff([fst:lst;], ids)[1]
    seat_id
end

@assert solve([
    "BFFFBBFRRR",
    "FFFBBBFRRR",
    "BBFFBBFRLL"
    ]) == 820

open("inputs/05.txt") do file
    data = readlines(file)
    # ENV["JULIA_DEBUG"] = Main
    println("Part 1: $(solve(data))")
    println("Part 2: $(solve2(data))")
end