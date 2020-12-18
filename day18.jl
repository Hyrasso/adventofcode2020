
function get_exp(line)
    Meta.parse(replace(line, "*" => "⩊"))
end

function get_exp2(line)
    Meta.parse(replace(replace(line, "+" => "⩋"), "*" => "⩊"))
end

⩋(a, b) = a + b # * precedence
⩊(a, b) = a * b # + precedence

function solve(exprs)
    sum(eval.(exprs))
end

@assert solve([get_exp("2 * 3 + (4 * 5)")]) == 26
@assert solve([get_exp("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")]) == 13632
@assert solve([get_exp2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")]) == 23340

open("inputs/18.txt") do file
    lines = readlines(file)
    exprs = get_exp.(lines)
    println("Part 1: $(solve(exprs))")
    exprs = get_exp2.(lines)
    println("Part 2: $(solve(exprs))")
end