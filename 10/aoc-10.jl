# load the arguments from the file
using Printf
using Statistics

if length(ARGS) != 1
    ErrorException("Please provide a path to a file with input.")
end;
file = open(ARGS[1], "r")
input = read(file, String)
lines = split(input, "\n")
lines = [l for l in lines if length(l) > 0]
@printf("Nb. of lines: %d\n", length(lines))
close(file)

cost = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)

opening = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')

completing_increase = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)

global total_cost = 0
global completing_costs = []
for l in lines
    pile = []
    incomplete = true
    for s in l
        if s in keys(opening)
            push!(pile, s)
        else
            if isempty(pile)
                global total_cost += cost[s]
                break
            end
            opened = pop!(pile)
            if s != opening[opened]
                global total_cost += cost[s]
                incomplete = false
                break
            end
        end
    end
    if incomplete
        local_completing_cost = 0
        while !isempty(pile)
            opened = pop!(pile)
            local_completing_cost *= 5
            local_completing_cost += completing_increase[opening[opened]]
        end
        append!(completing_costs, local_completing_cost)
    end
end

@printf("Total cost %d\n", total_cost)
@printf("Median completing cost %d\n", median(completing_costs))