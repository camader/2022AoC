using DataStructures
# for reading the file
# read once to get the number of stacks 
# read again 


f = open("day_5_input.txt","r")
lines = readlines(f)

# for line in lines
#     @show split(line)[1]
#     # if split(line)[1] == 1
#     #     @show line
#     # end
# end


function find_number_of_stacks(lines)
    previous_line = nothing
    for line in lines
        if isempty(line)
            break
        end
        previous_line = line
    end

    n_stacks = length(split(previous_line))
    @show n_stacks
    return n_stacks
end

function read_stack_configuration(n_stacks,lines)

    #stack = Stack{Int}()
    tmp_stacks = Vector{Stack{Char}}(undef,n_stacks)
    stacks = Vector{Stack{Char}}(undef,n_stacks)
    for i in 1:n_stacks
        tmp_stacks[i] = Stack{Char}()
        stacks[i] = Stack{Char}()
    end
    @show stacks
    for line in lines
        if isempty(line)
            break
        end
        line_array = collect(line)
        for i in 1:n_stacks
            idx = 4*(i-1)+2
            @show line_array[idx],idx,isletter(line_array[idx])
            if isletter(line_array[idx])
                push!(tmp_stacks[i],line_array[idx])
            end
        end
    end
    # flip the stacks
    for i in 1:n_stacks
        n_items = length(tmp_stacks[i])
        for j in 1:n_items
            item = pop!(tmp_stacks[i])
            push!(stacks[i],item)
        end
    end
    return stacks
end

function read_instructions(lines)
    start_read = false
    instructions = []
    for line in lines
        if isempty(line)
            start_read=true
            continue
        end
        if start_read
            @show split(line)
            @show split(line)[2],split(line)[4],split(line)[6]
            instruction = [parse(Int,split(line)[2]),parse(Int,split(line)[4]),parse(Int,split(line)[6])]
            push!(instructions,instruction)
        end
    end
    return instructions
end

function move_boxes!(stacks, instructions)

    for instruction in instructions
        n_boxes = instruction[1]
        @show typeof(n_boxes),n_boxes
        from_stack = instruction[2]
        to_stack = instruction[3]
        for i in 1:n_boxes
            item = pop!(stacks[from_stack])
            push!(stacks[to_stack],item)
        end
    end
end

function move_boxes_2!(stacks, instructions)

    for instruction in instructions
        n_boxes = instruction[1]
        @show typeof(n_boxes),n_boxes
        from_stack = instruction[2]
        to_stack = instruction[3]
        tmp_stack = Stack{Char}()
        for i in 1:n_boxes
            item = pop!(stacks[from_stack])
            push!(tmp_stack,item)
        end
        for i in 1:n_boxes
            item = pop!(tmp_stack)
            push!(stacks[to_stack],item)
        end
    end
end

function get_top_boxes(stacks, n_stacks)
    top_boxes = []
    for i in 1:n_stacks
        item = first(stacks[i])
        push!(top_boxes,item)
    end
    return top_boxes
end



n_stacks = find_number_of_stacks(lines)
@show n_stacks

stacks = read_stack_configuration(n_stacks,lines)
@show stacks

instructions = read_instructions(lines)
@show instructions

@show stacks
move_boxes_2!(stacks,instructions)
@show stacks

top_boxes = get_top_boxes(stacks,n_stacks)
@show top_boxes