function get_data(data)
    pattern = r"(\d+)-(\d+) ([a-z]): (\w+)"
    splitmatch(m) = parse(Int, m[1]), parse(Int, m[2]), m[3][1], m[4]
    l = collect(map(splitmatch, eachmatch(pattern, data)))
    # println(length(l))
    return l
end

"""
Call f with splatted argument.

    splat(f)(t) -> f(t...)
"""
splat(f) = (t) -> f(t...)

function solve(passwords)
    count(map(splat(
            (mini, maxi, letter, pass) -> mini <= count(e -> e === letter, pass) <= maxi
        ),
        passwords
    ))
end

function solve2(passwords)
    count(map(splat(
            (fst, scd, letter, pass) -> xor(pass[fst] == letter, pass[scd] == letter)
        ),
        passwords
    ))
end

@assert solve(get_data("""
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """)
) == 2

@assert solve2(get_data("""
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """)
) == 1

open("inputs/02-1.txt") do file
    data = get_data(read(file, String))
    println("Part 1: $(solve(data))")
    println("Part 2: $(solve2(data))")
end