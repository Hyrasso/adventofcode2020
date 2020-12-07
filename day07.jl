
function get_rules(data)
    rules = Dict()
    for line in data
        bag, contain = split(line, " bags contain ")
        if contain == "no other bags."
            rules[bag] = ()
        else
            bags = []
            indices = [i.start for i in findall(",", contain)]
            prepend!(indices, 1)
            for i in indices
                m = match(r"(\d+) (\w+ \w+)", contain, i)
                amount, color = m.captures[1], m.captures[2]
                push!(bags, (n=parse(Int, amount), c=color))
            end
            rules[bag] = tuple(bags...)
        end
    end
    rules
end

test_input = IOBuffer("""light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.""")

test_rules = get_rules(readlines(test_input))


function dfs(bag, rules)
    if bag == "shiny gold"
        return true
    end
    for child in rules[bag]
        if dfs(child.c, rules)
            return true
        end
    end
    false
end

function solve(rules)
    contain_sg = Set()
    for (bag, contain) in rules
        if bag == "shiny gold"
            continue
        end
        if dfs(bag, rules)
            push!(contain_sg, bag)
        end
    end
    length(contain_sg)
end

@assert (solve(test_rules)) == 4

function solve2(rules)
    q = [(c="shiny gold", n=1)]
    total = 0
    while length(q) > 0
        current = pop!(q)
        for bag in rules[current.c]
            total += bag.n * current.n
            push!(q, (c=bag.c, n=bag.n * current.n))
        end
    end
    total
end

@assert solve2(test_rules) == 32

test_input2 = IOBuffer("""shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.""")

@assert solve2(get_rules(readlines(test_input2))) == 126


open("inputs/07.txt") do file
    rules = get_rules(readlines(file))
    println("Part 1: $(solve(rules))")
    println("Part 2: $(solve2(rules))")
end