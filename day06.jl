
function solve(data, agg=union)
    groups = split(data, "\n\n")
    total = 0
    for group in groups
        total += length(foldl(agg, map(Set, split(group, "\n"))))
    end
    total
end

@assert solve("""abc

a
b
c

ab
ac

a
a
a
a

b""", union) == 11

@assert solve("""abc

a
b
c

ab
ac

a
a
a
a

b""", intersect) == 6

open("inputs/06.txt") do file
    data = read(file, String)
    data = replace(data, "\r" => "")
    println("Part 1: $(solve(data, union))")
    println("Part 2: $(solve(data, intersect))")
end