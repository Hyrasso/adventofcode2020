function get_program(data)
    # f = open("inputs/08-abs.txt", "w")
    program = []
    for (i, line) in enumerate(data)
        ins, arg = split(line, " ")
        ins, arg = Symbol(ins), parse(Int, arg)
        if ins in (:jmp, :nop)
            arg += i
        end
        # println(f, ins, " ", arg)
        push!(program, (ins, arg))
    end
    # close(f)
    program
end

function solve(program, visited=nothing)
    i = 1
    if visited === nothing
        visited = []
    end
    push!(visited, 1)
    acc = 0
    while true
        ins, arg = program[i]
        if ins == :jmp
            i = arg - 1
        elseif ins == :acc
            acc += arg
        elseif ins == :nop
        else
            @error (ins, arg)
        end
        i += 1
        if i ∈ visited
            return (acc, :inf)
        elseif  i == length(program) + 1
            return (acc, :exit)
        end
        push!(visited, i)
    end
end

function solve2(program)
    # list all jmp and nops encountered,
    # try to replace them until no loop is encountered
    visited = []
    solve(program, visited)
    change = Dict()
    for idx in visited
        ins, arg = program[idx]
        if ins in (:jmp, :nop)
            change[idx] = (ifelse(ins == :jmp, :nop, :jmp), arg)
        end
    end
    for (idx, ins) in change
        new_program = program[:]
        new_program[idx] = ins
        out = solve(new_program)
        if out[2] == :exit
            return out
        end
    end
end

test_program = get_program(readlines(IOBuffer("""nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6""")))

@assert solve(test_program) == (5, :inf)

@assert solve2(test_program) == (8, :exit)

open("inputs/08.txt") do file
    prog = get_program(readlines(file))
    println("Part 1: $(solve(prog))")
    println("Part 2: $(solve2(prog))")
end