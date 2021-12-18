if length(ARGS) != 1;
    ErrorException("Please provide a path to a file with directions.");
end;
file = open(ARGS[1], "r")
input = read(file, String)
lines = split(input, "\n")
close(file)

function decode_path(s)
    re = r"(\d+),(\d+) -> (\d+),(\d+)"
    m = match(re,s)
    if !isnothing(m) && length(m.captures) == 4
        return [1 + parse(Int, n) for n in m.captures]
    end
    return nothing
end

all_paths = [decode_path(s) for s in lines if !isnothing(decode_path(s))]
straight_paths = [(i1, j1, i2, j2) for (i1, j1, i2, j2) in all_paths if (i1 == i2) | (j1 == j2)]

function get_map(paths)
    min_hor = minimum([min(i1, i2) for (i1, j1, i2, j2) in all_paths])
    max_hor = maximum([max(i1, i2) for (i1, j1, i2, j2) in all_paths])
    min_ver = minimum([min(j1, j2) for (i1, j1, i2, j2) in all_paths])
    max_ver = maximum([max(j1, j2) for (i1, j1, i2, j2) in all_paths])
    println("Horizontal: ", min_hor, "-", max_hor)
    println("Vertical: ", min_ver, "-", max_ver)
    path_map = zeros(1+max_hor, 1+max_ver)
    for (i1, j1, i2, j2) in paths
        i_range, j_range = get_ranges(i1, j1, i2, j2)
        for (i,j) in zip(i_range, j_range)
            path_map[i,j] += 1
        end
    end
    return path_map
end

function get_ranges(i1, j1, i2, j2)
    if i1 == i2
        i_range = [i1 for _ in j1:sign(j2-j1):j2]
    else
        i_range = i1:sign(i2-i1):i2
    end
    if j1 == j2
        j_range = [j1 for _ in i1:sign(i2-i1):i2]
    else
        j_range = j1:sign(j2-j1):j2
    end
    return i_range, j_range
end

straight_map = get_map(straight_paths)

function is_multiple(x)
    return x >= 2
end

multiples = count(is_multiple, straight_map)
println(multiples)

all_map = get_map(all_paths)

multiples = count(is_multiple, all_map)
println(multiples)

if size(all_map)[1] < 100
    print("\n\n")
    for j in 1:size(all_map)[2]
        for i in 1:size(all_map)[1]
            value = all_map[i,j]
            if value == 0
                s = "."
            else
                s = string(floor(value))
            end
            print(s[1])
        end
        print("\n")
    end
end