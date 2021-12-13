# load the arguments from the file
using Printf

if length(ARGS) != 1
    ErrorException("Please provide a path to a file with input.")
end;
file = open(ARGS[1], "r")
lines = [l for l in readlines(file) if length(l) > 0]
close(file)
@printf("Nb. of lines: %d\n", length(lines))

# build the graph
pattern = r"([a-z]+)-([a-z]+)"i
vertices = []
edges = []
for l in lines
   m = match(pattern, l)
   from = String(m[1])
   to = String(m[2])
   for v in (from, to)
        if !(v in vertices)
            append!(vertices, [v])
        end
    end
    append!(edges, [(from, to)]) 
end

edges = unique(edges)

# println(simplified_vertices)
println(edges)

paths = []
function get_paths(edges, vertex, passed_edges)
    # println(passed_edges)
    # we reached the end
    if vertex == "end"
        append!(paths, [passed_edges])
        return
    end
    # get the local available edges
    connections = []
    new_edges = []
    for (from,to) in edges
        if (from == vertex) || (to == vertex)
            append!(connections, [(from,to)])
            if isuppercase(vertex[1])
                append!(new_edges, [(from,to)])
            end
        else
            append!(new_edges, [(from,to)])
        end
    end
    # generate new paths from connected vertices
    for (from, to) in connections
        # build copy of passed edges and vertices
        new_passed_edges = copy(passed_edges)
        append!(new_passed_edges, [(from,to)])
        if (from == vertex)
            get_paths(new_edges, to, new_passed_edges)
        else
            get_paths(new_edges, from, new_passed_edges)
        end
    end
end

get_paths(edges, "start", [])

@printf("First part: %d paths\n", length(paths))

function get_new_paths(edges, vertex, passed_edges, double)
    # println(passed_edges)
    # we reached the end
    if vertex == "end"
        append!(paths, [passed_edges])
        return
    end
    # get the local available edges
    connections = []
    new_edges = []
    for (from,to) in edges
        if (from == vertex) || (to == vertex)
            append!(connections, [(from,to)])
            if isuppercase(vertex[1])
                append!(new_edges, [(from,to)])
            end
        else
            append!(new_edges, [(from,to)])
        end
    end
    # generate new paths from connected vertices
    for (from, to) in connections
        # build copy of passed edges and vertices
        new_passed_edges = copy(passed_edges)
        append!(new_passed_edges, [(from,to)])
        if (from == vertex)
            get_new_paths(new_edges, to, new_passed_edges, double)
        else
            get_new_paths(new_edges, from, new_passed_edges, double)
        end
    end
    # get paths with double small cave possibility
    if !double && (vertex != "start")
        connections = []
        for (from,to) in edges
            if (from == vertex) || (to == vertex)
                append!(connections, [(from,to)])
            end
        end
        # generate new paths from connected vertices
        for (from, to) in connections
            # build copy of passed edges and vertices
            new_passed_edges = copy(passed_edges)
            append!(new_passed_edges, [(from,to)])
            if (from == vertex)
                get_new_paths(edges, to, new_passed_edges, true)
            else
                get_new_paths(edges, from, new_passed_edges, true)
            end
        end
    end
end

paths = []
get_new_paths(edges, "start", [], false)

@printf("Second part: %d paths\n", length(paths))
