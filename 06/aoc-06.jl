# load the arguments from the file
using Printf

if length(ARGS) != 1;
    ErrorException("Please provide a path to a file with directions.");
end;
file = open(ARGS[1], "r")
input = read(file, String)
lines = split(input, "\n")
close(file)

# build an array of cycle position of fish
cycles = zeros(9)
for s in split(input, ",")
    if length(s) > 0
        # our cycles are from 1 to 9 because of Julia's 1-indexing
        n = 1 + parse(Int, s)
        cycles[n] += 1
    end
end

println(cycles)

# time-passing function
function pass_time()
    # store the number of fish at the end of the cycle
    m = cycles[1]
    # move each cycle age to one less
    for i in 2:9
        cycles[i-1] = cycles[i]
    end
    # create new fish and reset the cycle
    cycles[9] = m
    cycles[7] += m
end

n_cycles = 80
for k in 1:n_cycles
    pass_time()
end

@printf("Number of fish after %d cycles: %f\n", n_cycles, sum(cycles))

n_cycles_longer = 256
for k in (n_cycles+1):n_cycles_longer
    pass_time()
end

@printf("Number of fish after %d cycles: %f\n", n_cycles_longer, sum(cycles))