
function get_rules(lines)
    rules = Dict()
    for l in lines
        rn, rule = split(l, ": ")
        rn = parse(Int, rn)
        if rule == "\"a\""
            rules[rn] = 'a'
        elseif rule == "\"b\""
            rules[rn] = 'b'
        else
            subrules = split(rule, "|")
            sr = []
            for subrule in subrules
                push!(sr, parse.(Int, split(subrule)))
            end
            rules[rn] = sr
        end
    end
    rules
end

test_rules = get_rules(readlines(IOBuffer("""0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b\"""")))
@assert length(test_rules) == 6


function imatch_message(message, rules, rule)
    if length(message) == 0
        return []
    end
    rule = rules[rule]
    if isa(rule, Char)
        if message[1] == rule
            return [1]
        else
            return []
        end
    end
    offsets = []
    for r in rule
        # TODO: use a recursive thingy to be able to match any number of consecutive rules
        for offset in imatch_message(message, rules, r[1])
            if length(r) == 1
                push!(offsets, offset)
            elseif length(r) == 2
                append!(offsets, offset .+ imatch_message(message[offset+1:end], rules, r[2]))
            else
                for offset in (offset .+ imatch_message(message[offset+1:end], rules, r[2]))
                    append!(offsets, offset .+ imatch_message(message[offset+1:end], rules, r[3]))
                end
            end
        end
    end
    # @show message, rule, offsets
    return offsets
end

# @show imatch_message("ababbb", test_rules, 0)

function match_message(rules, message)
    length(message) in imatch_message(message, rules, 0)
end

@assert match_message(test_rules, "ababbb") == true
@assert match_message(test_rules, "bababa") == false

function solve(messages, rules)
    sum(match_message(rules, message) for message in messages)
end

open("inputs/19.txt") do file
    lines = readlines(file)
    rule_end_idx = findfirst(==(0) ∘ length, lines)
    rules = get_rules(lines[1:rule_end_idx-1])
    messages = lines[rule_end_idx+1:end]
    println("Part 1: $(solve(messages, rules))")
    rules[8] = [[42], [42, 8]]
    rules[11] = [[42, 31], [42, 11, 31]]
    println("Part 2: $(solve(messages, rules))")
end