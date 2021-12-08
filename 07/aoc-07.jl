# load the arguments from the file
using Printf

if length(ARGS) != 1;
    ErrorException("Please provide a path to a file with directions.");
end;
file = open(ARGS[1], "r")
input = read(file, String)
lines = split(input, "\n")
close(file)

positions = [parse(Int,s) for s in split(input,",") if length(s) > 0]
unique_pos = unique(positions)

fuel_cost = minimum([
    sum([
        abs(x-y)
        for x in positions
    ]) 
    for y in positions
])

println(fuel_cost)

fuel_cost = minimum([
    sum([
        abs(x-y)*(abs(x-y)+1)/2
        for x in positions
    ]) 
    for y in minimum(positions):maximum(positions)
])

@printf("%.0f", fuel_cost)