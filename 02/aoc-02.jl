# print the arguments
print("ARGS: ", ARGS)
if length(ARGS) != 1;
    ErrorException("Please provide a path to a file with directions.");
end;

# get the commands from the first input
file = open(ARGS[1], "r")
l = readlines(file)
close(file)
print("\nl is of length ", length(l), "\n")

# First part: get the depth and the horizontal displacement
depth = 0
horiz = 0
for element in l;
    direction, distance = split(element, " ");
    distance = parse(Int, distance);
    if startswith(direction, "f");
        global horiz += distance
    elseif startswith(direction, "u")
        global depth -= distance
    else
        global depth += distance
    end
end

print("\nFirst part: ", depth*horiz, "\n")

# Second part: introducing aim
depth, horiz, aim=0,0,0

for element in l;
    direction, distance = split(element, " ");
    distance = parse(Int, distance);
    if startswith(direction, "u");
        global aim -= distance
    elseif startswith(direction, "d")
        global aim += distance
    else
        global horiz += distance
        global depth += distance*aim
    end
end

print("\nSecond part: ", depth*horiz, "\n")
