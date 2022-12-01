#f = open("test_input.txt","r")
f = open("puzzle1_input.txt","r")
lines = readlines(f)
for line in lines
    @show line
end
# elves = Dict{UInt32,Int}()
# sum = 0
# global counter = 1
# for line in lines
#     if isempty(line)
#         @show "empty"
#         elves[global counter] = sum
#         global sum = 0
#         global counter +=1
#     else
#         @show line,parse(Int,line)
#         global sum += parse(Int,line)
#         @show sum
#     end
# end

function count_calories(lines)
    elves = Dict{Int,Int}()
    sum = 0
    counter = 1
    for line in lines
        if !isempty(line)
            @show line,parse(Int,line)
            sum += parse(Int,line)
            @show sum
        else
                @show "empty"
                elves[counter] = sum
                sum = 0
                counter +=1
        end
    end
    elves[counter] = sum
    sum = 0
    counter +=1
    return elves
end

elves = count_calories(lines)

@show elves, argmax(elves)
@show argmax(elves),elves[argmax(elves)]

function count_n_max_calories(elves, n)
    sum = 0
    for i in 1:num_elves
        ind = argmax(elves)
        sum += pop!(elves, ind)
        @show sum
    end
    return sum
end

num_elves = 3

max3 = count_n_max_calories(elves,num_elves)
@show max3


close(f)