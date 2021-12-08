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

#    8:
#   aaaa
#  b    c
#  b    c
#   dddd
#  e    f
#  e    f
#   gggg

uniques = Array{Vector}(undef, length(lines))
outputs = Array{Vector}(undef, length(lines))
for (i, l) in enumerate(lines)
    u, o = split(l, "|")
    uniques[i] = [String(s) for s in split(u)]
    outputs[i] = [String(s) for s in split(o)]
end

# true codes of the digits, translated by 1
codes = Array{String}(undef, 10)
codes[1] = "abcefg" # 0
codes[2] = "cf" # 1
codes[3] = "acdeg" # 2
codes[4] = "acdfg" # 3
codes[5] = "bcdf" # 4
codes[6] = "abdfg" # 5
codes[7] = "abdefg" # 6
codes[8] = "acf" # 7
codes[9] = "abcdefg" # 8
codes[10] = "abcdfg" # 9
# number of letters for each digit, translated by 1
n_letters = [length(s) for s in codes]

length_1478 = [n_letters[i+1] for i in [1, 4, 7, 8]]
first_part = 0
for o in outputs
    for s in o
        if length(s) in length_1478
            global first_part += 1
        end
    end
end
@printf("First part %.0f\n", first_part)

function init_decode()::Dict{Char,Char}
    return Dict(s => s for s in ['a', 'b', 'c', 'd', 'e', 'f', 'g'])
end

function get_set(uni::Vector{String}, i::Int)::Set{Char}
    codes = filter(s -> length(s) == n_letters[i+1], uni)
    if length(codes) == 1
        return Set(codes[1])
    else
        ErrorException("get_set received non-unique code length")
    end
end

function get_sets(uni::Vector{String}, i::Int)::Vector{Set{Char}}
    codes = filter(s -> length(s) == n_letters[i+1], uni)
    return [Set(c) for c in codes]
end


function decode(uni::Vector{String})::Dict{Char,Char}
    d = init_decode()
    # get 1, 4 and 7
    one = get_set(uni, 1)
    four = get_set(uni, 4)
    seven = get_set(uni, 7)
    # get [cf] from 1
    cf = one
    # get [bd] from 4 \ 1
    bd = setdiff(four, one)
    # get [a] from 7 \ 1
    d['a'], = setdiff(seven, one)
    # get 5-letter codes
    two_three_five = get_sets(uni, 5)
    # remove [abdcf] to isolate [eg] and identify 2
    abdcf = Set([s for s in Base.Iterators.flatten([d['a'], bd, cf])])
    diffs_235_abcdf = [setdiff(s, abdcf) for s in two_three_five]
    # 3 or 5 minus [abdcf] is [g]
    three_five_diff = [sdiff for sdiff in diffs_235_abcdf if length(sdiff) == 1]
    # 2 minus [abdcf] is [eg]
    two, = [s for (s, sdiff) in zip(two_three_five, diffs_235_abcdf) if length(sdiff) == 2]
    eg, = [sdiff for sdiff in diffs_235_abcdf if length(sdiff) == 2]
    # get the remaining letters
    d['g'], = three_five_diff[1]
    d['e'], = setdiff(eg, d['g'])
    d['d'], = intersect(two, bd)
    d['b'], = setdiff(bd, d['d'])
    d['c'], = intersect(two, cf)
    d['f'], = setdiff(cf, d['c'])
    # reverse the dict to get a decoder
    return inverse_dict(d)
end

function inverse_dict(d::Dict{Char,Char})::Dict{Char,Char}
    return Dict(v => k for (k, v) in zip(keys(d), values(d)))
end

function translate(decoder::Dict{Char,Char}, code::String)::Int
    # get the decoded code of the number
    int_code = String([decoder[c] for c in code])
    # locate the corresponding number (could inverse codes at the start to speed up)
    int_plus_1, = [i for (i, s) in enumerate(codes) if Set(s) == Set(int_code)]
    return int_plus_1 - 1
end

second_part = 0
for (u, o) in zip(uniques, outputs)
    # get the decoder for this line
    decoder = decode(u)
    # get the coresponding decoded output in base 10
    global second_part +=
        sum([translate(decoder, s) * 10^(4 - i) for (i, s) in enumerate(o)])
end

@printf("Second part: %.0f\n", second_part)
