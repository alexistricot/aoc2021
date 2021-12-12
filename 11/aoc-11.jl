# load the arguments from the file
using Printf

if length(ARGS) != 1
    ErrorException("Please provide a path to a file with input.")
end;
file = open(ARGS[1], "r")
input = read(file, String)
lines = split(input, "\n")
lines = [l for l in lines if length(l) > 0]
@printf("Nb. of lines: %d\n", length(lines))
close(file)

# 
n_row = length(lines)
n_col = length(lines[1])
function load_mat()
    mat = Array{Int}(undef, n_row, n_col)
    for (i, l) in enumerate(lines)
        for (j, s) in enumerate(l)
            mat[i, j] = parse(Int, s)
            print(mat[i, j])
        end
        println()
    end
    return mat
end

mat = load_mat()

increase = ones(Int, n_row, n_col)
function step()::Vector{Any}
    global mat += increase
    # flashing octopuses
    flash = []
    # octopuses about to flash
    nines = [(i, j) for i = 1:n_row for j in 1:n_col if mat[i, j] == 10]
    while !isempty(nines)
        # make an octopus flash
        (i, j) = pop!(nines)
        append!(flash, [(i, j)])
        mat[i,j] = 0
        # update energy level of nearby octopuses
        for (m, n) in adjacent(i, j, flash)
            mat[m, n] += 1
            # handle about-to-flash nearby octopus
            if mat[m, n] == 10
                append!(nines, [(m, n)])
            end
        end
    end
    return flash
end

function adjacent(i::Int, j::Int, flash::Vector{Any})
    im1 = max(1, i - 1)
    ip1 = min(n_row, i + 1)
    jm1 = max(1, j - 1)
    jp1 = min(n_row, j + 1)
    adj = [
        (im1, j),
        (im1, jm1),
        (i, jm1),
        (ip1, jm1),
        (ip1, j),
        (ip1, jp1),
        (i, jp1),
        (im1, jp1),
    ]
    # println("adjacent to ", (i, j), " : ", [x for x in unique(adj) if !(x in flash)])
    return [x for x in unique(adj) if !(x in flash)]
end

# first part

n_steps = 100
n_flashes = 0
for n = 1:n_steps
    flashes = step()
    # println(flashes)
    global n_flashes += length(flashes)
end

@printf("First part: %d\n", n_flashes)

# Second part

mat = load_mat()
sync_flashes = 0
iters = 0
max_iter = 1000
while sync_flashes == 0 && iters < max_iter
    global iters += 1
    flashes = step()
    if length(flashes) == n_row * n_col
        println(mat)
        global sync_flashes = iters
    end
end

@printf("Second part: %d\n", sync_flashes)
