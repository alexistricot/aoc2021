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

# Fill the matrix
global n_row = length(lines)
global n_col = length(lines[1])
levels = Array{Int}(undef, n_row, n_col)
for (i, row) in enumerate(lines)
    for (j, s) in enumerate(row)
        levels[i, j] = parse(Int, s)
    end
end

# First part
global score = 0
global min_levels = []

function is_min(
    levels::Array{Int},
    i::Int,
    j::Int,
    do_previous_i::Bool,
    do_previous_j::Bool,
)
    if (i > n_row) || (j > n_col) || through[i, j]
        return
    end
    through[i, j] = true
    n = levels[i, j]
    # get the adjacent numbers
    comp = []
    if (i == n_row)
        if do_previous_i
            append!(comp, [(i - 1, j)])
        end
    elseif (i == 1) || (!do_previous_i)
        append!(comp, [(i + 1, j)])
    else
        append!(comp, [(i + 1, j)])
        append!(comp, [(i - 1, j)])
    end
    if (j == n_col)
        if do_previous_j
            append!(comp, [(i, j - 1)])
        end
    elseif (j == 1) || (!do_previous_j)
        append!(comp, [(i, j + 1)])
    else
        append!(comp, [(i, j + 1)])
        append!(comp, [(i, j - 1)])
    end
    # compare to the adjacent numbers
    infs = filter(tup -> levels[tup[1], tup[2]] <= n, comp)
    # current number is a local minimum
    if length(infs) == 0
        global score += n + 1
        append!(min_levels, [(i, j)])
        println(i, ", ", j)
        is_min(levels, i + 2, j, true, true)
        is_min(levels, i, j + 2, true, true)
    else
        if (i + 1, j) in infs
            # levels[a,b] < levels[i,j]
            is_min(levels, i + 1, j, false, true)
        else
            is_min(levels, i + 2, j, true, true)
        end
        if (i, j + 1) in infs
            # levels[a,b] < levels[i,j]
            is_min(levels, i, j + 1, true, false)
        else
            is_min(levels, i, j + 2, true, true)
        end
    end
end

global through = fill(false, n_row, n_col)
is_min(levels, 1, 1, false, false)
for i = 1:n_row
    for j = 1:n_col
        if through[i, j]
            printstyled(levels[i, j], color = :bold)
        else
            printstyled(levels[i, j], color = :normal)
        end
    end
    print("\n")
end

@printf("First part: %d\n", score)

println(min_levels)

# Second part

function get_basin_size(levels::Array{Int}, i::Int, j::Int)
    # mark this level as passed through
    through[i, j] = true
    # end recursion
    if levels[i, j] == 9
        return 0
    end
    # adjacent numbers
    tups = [
        (max(i - 1, 1), j),
        (min(i + 1, n_row), j),
        (i, max(j - 1, 1)),
        (i, min(j + 1, n_col)),
    ]
    # get the basin sizes for all unvisited adjacent levels
    visit = [get_basin_size(levels, a, b) for (a, b) in tups if !through[a, b]]
    # if all adjacent levels have been visited, return one for the current level
    if length(visit) == 0
        return 1
    end
    # add one to basin size for the current level, and add adjacent unvisited levels basin sizes
    return 1 + sum(visit)
end

basin_sizes = []
for (i, j) in min_levels
    global through = fill(false, n_row, n_col)
    append!(basin_sizes, get_basin_size(levels, i, j))
end

println(basin_sizes)

@printf(
    "Second part: %d\n",
    sort(basin_sizes)[end] * sort(basin_sizes)[end-1] * sort(basin_sizes)[end-2]
)
