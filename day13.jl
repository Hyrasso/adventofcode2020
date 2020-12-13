
function get_buses(data)
    parse.(Int, filter(!=("x"), split(data[2], ","))), parse(Int, data[1])
end

function solve(buses, ts)
    next_depart = mod.(ts, buses)
    wait = buses .- next_depart
    idx = argmin(wait)

    buses[idx] * wait[idx]
end

test_input = IOBuffer("""939
7,13,x,x,59,x,31,19""")
test_buses = get_buses(readlines(test_input))

@assert solve(test_buses...) == 295

open("inputs/13.txt") do file
    buses, ts = get_buses(readlines(file))
    println("Part 1: $(solve(buses, ts))")
end