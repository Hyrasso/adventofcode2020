
bitarray_to_int(ba) = sum(2 .^ [35:-1:0;] .* ba)

@assert bitarray_to_int(collect("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") .== '1') == 64
@assert bitarray_to_int(collect("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") .== '0') == 2

function get_init_prog(data)
    get_ins_mask(mask) = (:mask, (set=bitarray_to_int(mask .== '1'), reset=bitarray_to_int(mask .!= '0'), floating=mask .== 'X'))
    get_ins_write(addr, value) = (:write, (addr=parse(UInt64, addr), value=parse(UInt64, value)))
    data = split.(data, " = ")
    [
        startswith(a, "mask") ? 
            get_ins_mask(collect(b)) :
            get_ins_write(a[5:end-1], b)
        for (a, b) in data
    ]
end

test_input = readlines(IOBuffer("""mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"""))

test_prog = get_init_prog(test_input)

function solve(init_prog)
    mem = Dict()
    set, reset = (0, 0)
    for (ins, args) in init_prog
        if ins == :mask
            set, reset = args.set, args.reset
        elseif ins == :write
            value = (args.value | set) & reset 
            mem[args.addr] = value
        end
    end
    sum(values(mem))
end

@assert solve(test_prog) == 165

function get_addrs(floating)
    nb = sum(floating)
    ba = BitArray(zeros(nb))
    po2 = 2 .^ [35:-1:0;][findall(floating)]
    r = []
    for i in 1:(2^nb)
        ba.chunks[1] = i
        push!(r, sum(ba .* po2))
    end
    r
end

@assert Set(get_addrs(BitArray([zeros(32)..., 1, 0, 1, 1]))) == Set([0, 1, 2, 3, 8, 9, 10, 11])

function solve2(init_prog)
    mem = Dict()
    set, reset, floating = (0, 0, 0)
    for (ins, args) in init_prog
        if ins == :mask
            set, reset, floating = args
        elseif ins == :write
            base_addr = args.addr & ~sum(floating .* 2 .^ [35:-1:0;]) | set
            for floating_address in get_addrs(floating)
                address = base_addr | floating_address
                mem[address] = args.value
            end
        end
    end
    sum(values(mem))
end

test_input = readlines(IOBuffer("""mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1"""))

@assert solve2(get_init_prog(test_input)) == 208

open("inputs/14.txt") do file
    init_prog = get_init_prog(readlines(file))
    println("Part 1: $(solve(init_prog))")
    println("Part 2: $(solve2(init_prog))")
end