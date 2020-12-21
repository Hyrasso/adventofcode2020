function get_food(lines)
    food = []
    for l in lines
        ii = findfirst("(", l).start
        ingredients = Symbol.(split(l[1:ii-1]))
        allergens = Symbol.(split(l[ii+10:end-1], ", "))
        push!(food, (ingredients, allergens))
    end
    food
end

test_input = readlines(IOBuffer("""mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"""))

test_food = get_food(test_input)
# @info test_food

function solve(food)
    allegerns = Dict()
    for (ing, allegs) in food
        for alleg in allegs
            push!(get!(() -> [], allegerns, alleg), ing)
        end
    end
    # @info allegerns
    potential_allegern = []
    for (allegern, potential) in allegerns
        ing = reduce(intersect, potential)
        append!(potential_allegern, ing)
    end
    # @info potential_allegern
    length(filter( ∘(!, in(Set(potential_allegern))), collect(Iterators.flatten(first.(food)))))
end

@assert solve(test_food) == 5

function solve2(food)
    allegerns = Dict()
    for (ing, allegs) in food
        for alleg in allegs
            push!(get!(() -> [], allegerns, alleg), ing)
        end
    end
    potential_allegerns = Dict()
    for (allegern, potential) in allegerns
        ing = reduce(intersect, potential)
        potential_allegerns[allegern] = Set(ing)
    end
    # @info potential_allegerns
    alleg_ing = []
    while !isempty(potential_allegerns)
        for (alleg, ings) in potential_allegerns
            setdiff!(ings, first.(alleg_ing))
            if length(ings) == 1
                delete!(potential_allegerns, alleg)
                push!(alleg_ing, (first(ings), alleg))
                @goto continue_while
            end
        end
        @error potential_allegerns
        break
        @label continue_while
    end
    # @info alleg_ing
    join(first.(sort(alleg_ing, by=last)), ",")
end

@assert solve2(test_food) == "mxmxvkd,sqjhc,fvjkl"

open("inputs/21.txt") do file
    food = readlines(file) |> get_food
    println("Part 1: $(solve(food))")
    println("Part 2: $(solve2(food))")
end