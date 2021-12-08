# load the arguments from the file
if length(ARGS) != 1;
    ErrorException("Please provide a path to a file with directions.");
end;
file = open(ARGS[1], "r")
input = read(file, String)
lines = split(input, "\n")
close(file)

# get the numbers input
numbers = [parse(Int, s) for s in split(lines[1], ",")]
println("min: ", minimum(numbers))
println("max: ", maximum(numbers))
println("length: ", length(numbers))
println("unique length: ", length(unique(numbers)))

# get the boards
# boards are separated by two new lines
number_positions = Array{Vector}(undef, 1 + maximum(numbers) - minimum(numbers))
str_boards = split(input, "\n\n")[2:end]
n_boards = length(str_boards)
boards = Array{Int}(undef, n_boards,5,5)
for (k, mat) in enumerate(str_boards)
    mat = strip(mat)
    for (i, vect) in enumerate(split(mat, "\n"))
        vect = strip(vect)
        for (j, s) in enumerate(split(vect))
            s = strip(s)
            num_minus_1 = parse(Int, s)
            boards[k,i,j] = num_minus_1
            num = 1 + num_minus_1
            if !isassigned(number_positions, num)
                # board number, row number, column number 
                number_positions[num] = [(k,i,j)]
            else
                # board number, row number, column number 
                append!(number_positions[num], [(k,i,j)])
            end
        end
    end
end

function is_bingo(board_tuples)
    if length(board_tuples) < 5
        return (false,[])
    end
    for rowcol in 1:5
        bingorow = filter(get_tup_filter(rowcol, 1), board_tuples)
        if length(bingorow) == 5
            return (true, bingorow)
        end
        bingocol = filter(get_tup_filter(rowcol, 2), board_tuples)
        if length(bingocol) == 5
            return (true, bingocol)
        end
    end
    return (false, [])
end

function get_tup_filter(rowcol, axis)
    return function (tup)
        return tup[axis] == rowcol
    end
end

function get_score(mat, tuples)
    total_sum = sum(mat)
    for (_,_,n) in tuples
        total_sum -= n
    end
    return total_sum
end

function search_first_bingo()
    # initialize the boards crossed elements
    crossed_boards = Array{Vector}(undef, n_boards)
    for n_minus_1 in numbers
        # deal with 0-indexing of numbers, back to Julia's 1-indexing
        n = n_minus_1 + 1
        # get the position of n in boards
        for (board, row, col) in number_positions[n]
            if !isassigned(crossed_boards, board)
                crossed_boards[board] = []
            end
            append!(crossed_boards[board], [(row, col, n_minus_1)])
            (bingo, rowcol) = is_bingo(crossed_boards[board])
            if bingo
                println("\nBingo on board ", board)
                println("Tuples: ", rowcol)
                score = get_score(boards[board,:,:], crossed_boards[board])
                println("Score*number: ", score, " * ", n_minus_1, " = ", score*n_minus_1)
                return
            end
        end
    end
end

# First part resolve
search_first_bingo()

# Second part
println("\nSecond part\n")

function search_last_bingo()
    # initialize the boards crossed elements
    crossed_boards = Array{Vector}(undef, n_boards)
    bingo_boards = zeros(n_boards)
    for n_minus_1 in numbers
        # deal with 0-indexing of numbers, back to Julia's 1-indexing
        n = n_minus_1 + 1
        # get the position of n in boards
        board = 
        for (board, row, col) in number_positions[n]
            if !isassigned(crossed_boards, board)
                crossed_boards[board] = []
            end
            append!(crossed_boards[board], [(row, col, n_minus_1)])
            (bingo, rowcol) = is_bingo(crossed_boards[board])
            if bingo
                bingo_boards[board] = 1
                if sum(bingo_boards) == n_boards
                    score = get_score(boards[board,:,:], crossed_boards[board])
                    println("\nBingo on board ", board)
                    println("Score*number: ", score, " * ", n_minus_1, " = ", score*n_minus_1)
                    return
                end
            end
        end
    end
end

search_last_bingo()