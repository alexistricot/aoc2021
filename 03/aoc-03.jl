# load the arguments from the file
if length(ARGS) != 1;
    ErrorException("Please provide a path to a file with directions.");
end;
file = open(ARGS[1], "r")
byte_list = readlines(file)
close(file)

nbytes = length(byte_list)
byte_length = length(byte_list[1])
print("\nnbytes: ", nbytes, "\n")
print("\nbyte_length: ", byte_length, "\n")


function get_gamma(byte_list)
    return sum([
        sum([parse(Int,s[i]) for s in byte_list]) > (nbytes / 2) ? 2^(byte_length - i) : 0 
        for i in 1:byte_length
    ])
end

function get_epsilon(gamma)
    return sum([
        sum([parse(Int,s[i]) for s in byte_list]) < (nbytes / 2) ? 2^(byte_length - i) : 0 
        for i in 1:byte_length
    ])
end

# First part

gamma = get_gamma(byte_list)
epsilon = get_epsilon(gamma)

print("\nFirst part\n")
print("\ngamma: ", gamma, "\n")
print("\nepsilon: ", epsilon, "\n")
print("\nproduct: ", epsilon*gamma, "\n")

# Second part

function oxygen_rating(byte_list)
    global index = 1
    while length(byte_list) > 1
        ones_sum = sum([parse(Int,s[index]) for s in byte_list])
        if ones_sum >= (length(byte_list) / 2)
            selection = [parse(Int,s[index]) == 1 for s in byte_list]
            byte_list = byte_list[selection]
        else
            selection = [parse(Int,s[index]) == 0 for s in byte_list]
            byte_list = byte_list[selection]
        end
        global index += 1
    end
    print("\n", byte_list[1], "\n")
    return sum([parse(Int,s) > 0 ? 2^(byte_length - i) : 0 for (i,s) in enumerate(byte_list[1])])
end

function co2_rating(byte_list)
    global index = 1
    while length(byte_list) > 1
        ones_sum = sum([parse(Int,s[index]) for s in byte_list])
        if ones_sum < (length(byte_list) / 2)
            selection = [parse(Int,s[index]) == 1 for s in byte_list]
            byte_list = byte_list[selection]
        else
            selection = [parse(Int,s[index]) == 0 for s in byte_list]
            byte_list = byte_list[selection]
        end
        global index += 1
    end
    print("\n", byte_list[1], "\n")
    return sum([parse(Int,s) > 0 ? 2^(byte_length - i) : 0 for (i,s) in enumerate(byte_list[1])])
end

print("\nSecond part\n")
ox_rate = oxygen_rating(byte_list)
co2_rate = co2_rating(byte_list)
print("\noxygen rating :", ox_rate, "\n")
print("\nco2 rating :", co2_rate, "\n")
print("\nproduct: ", co2_rate * ox_rate, "\n\n")
