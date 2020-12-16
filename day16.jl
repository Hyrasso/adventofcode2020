function parse_input(lines)
    own_ticket_idx = findfirst(==("your ticket:"), lines)
    other_tickets_idx = findfirst(==("nearby tickets:"), lines)

    own_ticket = parse.(Int, split(lines[own_ticket_idx+1], ","))
    tickets = map(l -> parse.(Int, l), split.(lines[other_tickets_idx+1:end], ","))
    rules = Dict()
    for i in 1:own_ticket_idx-2
        rule = []
        for m in eachmatch(r"(\d+)-(\d+)", lines[i])
            from, to = parse.(Int, m.captures)
            push!(rule, from:to)
        end
        fielnamend = findfirst(":", lines[i]).start -1
        rules[lines[i][1:fielnamend]] = rule
    end
    rules, own_ticket, tickets
end

function invalid_value(value, rules, default)
    if !any(any(in.(value, rule)) for rule in rules)
        value
    else
        default
    end
end

function solve(tickets, rules)
    sum(
        invalid_value(value, rules, 0) for ticket in tickets for value in ticket
    )
end

function is_valid(ticket, rules)
    all(any(any(in.(value, rule)) for rule in rules) for value in ticket)
end

@assert is_valid([7,3,47], [[1:3, 5:7], [6:11, 33:44], [13:40, 45:50]]) == true
@assert is_valid([40,4,50], [[1:3, 5:7], [6:11, 33:44], [13:40, 45:50]]) == false

function valid_pos(rule, idx, tickets)
    all(any(in.((ticket[idx]), rule)) for ticket in tickets)
end

@assert valid_pos([0:5, 8:91], 1, [[3,9,18],[15,1,5],[5,14,9]]) == true
@assert valid_pos([0:1, 14:19], 1, [[3,9,18],[15,1,5],[5,14,9]]) == false

""" The heck -_-
"""
function solve2(tickets, rules, own_ticket)
    tickets = filter(t -> is_valid(t, values(rules)), tickets)
    pos = zeros((length(rules), length(rules)))
    rules_array = collect(rules)
    for (i, (field, rule)) in enumerate(rules_array)
        for j in 1:length(rules)
            if valid_pos(rule, j, tickets)
                pos[j, i] = 1
            end
        end
    end

    fields = Dict()
    keys_array = [k for (k,_) in rules_array]
    for i in 1:length(rules)
        # println(join([join([ifelse(e==1,"#"," ") for e in pos[ip,1:end]], "") for ip in 1:20], "\n"))
        min_idx = findfirst(vec(sum(pos, dims=1) .== 1))
        field_idx = findfirst(pos[1:end, min_idx] .== 1)
        fields[keys_array[min_idx]] = field_idx 
        pos[field_idx, 1:end] .= 0
    end

    r = 1
    for (k, idx) in fields
        if startswith(k, "departure")
            r *= own_ticket[idx]
        end
    end
    r
end

@assert solve(
    [[7,3,47], [40,4,50], [55,2,20], [38,6,12]],
    [[1:3, 5:7], [6:11, 33:44], [13:40, 45:50]]
    ) == 71

open("inputs/16.txt") do file
    rules, own_ticket, tickets = parse_input(readlines(file))
    println("Part 1: $(solve(tickets, values(rules)))")
    println("Part 2: $(solve2(tickets, rules, own_ticket))")
end