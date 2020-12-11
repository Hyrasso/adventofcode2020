
function get_seat_map(lines)
    seats = permutedims(hcat(collect.(lines)...), (2,1)) .== 'L'
    seats
end

function solve(seats)
    h, w = size(seats)
    occupied = BitArray(ones((h, w)))
    new_occupied = BitArray(zeros((h, w)))
    while any(occupied .!= new_occupied)
        occupied = copy(new_occupied)
        # @show seats
        for i in 1:w, j in 1:h
            if !seats[j,i] continue end
            s = sum([get(occupied, (cj, ci), 0) for ci in i-1:i+1, cj in j-1:j+1])
            # @show i, j, seats[j, i], s
            if !occupied[j, i] && s == 0
                new_occupied[j, i] = true
            elseif occupied[j, i] && s > 4
                new_occupied[j, i] = false
            end
        end
    end
    sum(new_occupied)
end

function solve2(seats)
    h, w = size(seats)
    occupied = BitArray(ones((h, w)))
    new_occupied = BitArray(zeros((h, w)))
    while any(occupied .!= new_occupied)
        occupied = copy(new_occupied)
        # @show seats
        for i in 1:w, j in 1:h
            if !seats[j,i] continue end
            function get_first_seat(ci, cj)
                if (ci, cj) == (0, 0) return occupied[j, i] end
                ni, nj = i+ci, j+cj
                while  get(seats, (nj, ni), nothing) !== nothing
                    if seats[nj, ni]
                        return occupied[nj, ni]
                    else
                        ni, nj = ni+ci, nj+cj
                    end
                end
                false
            end
            s = sum([get_first_seat(cj, ci) for ci in -1:1, cj in -1:1])
            if !occupied[j, i] && s == 0
                new_occupied[j, i] = true
            elseif occupied[j, i] && s > 5
                new_occupied[j, i] = false
            end
        end
    end
    sum(new_occupied)
end

test_input = IOBuffer("""L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL""")

test_seats = readlines(test_input)
@assert solve(get_seat_map(test_seats)) == 37
@assert solve2(get_seat_map(test_seats)) == 26

open("inputs/11.txt") do file
    seats = get_seat_map(readlines(file))
    println("Part 1: $(solve(seats))")
    println("Part 2: $(solve2(seats))")
end