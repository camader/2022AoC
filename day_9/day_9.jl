f = open("day_9_input.txt","r")
#f = open("test_input_2.txt","r")
#f = open("test_input.txt","r")
lines = readlines(f)

struct Instruction
    direction::String
    distance::Int
end


# for line in lines 
#     @show line
# end


function read_instructions(lines)
    instructions = Vector{Instruction}()
    for line in lines
        vals = split(line)
        tmp = Instruction(vals[1],parse(Int,vals[2]))
        push!(instructions,tmp)
    end
    return instructions
end

function run_instructions(instructions)
    start_point = (1,1)
    tail_point = (1,1)

    history = Set{Tuple{Int,Int}}()
    tail_history = Set{Tuple{Int,Int}}()
    push!(history,start_point)
    push!(tail_history,tail_point)
    for instruction in instructions
        start_point,tail_point = move_rope(start_point,tail_point,history,tail_history,instruction)
        #start_point = end_point
    end
    return history,tail_history
end

function move_rope(start_point,tail_point,point_history,tail_history, instruction)
    n_steps = instruction.distance
    dir = instruction.direction
    x0 = start_point[1]
    y0 = start_point[2]
    for i in 1:n_steps
        if dir == "U"
            dx = 0
            dy = 1
        elseif dir == "R"
            dx = 1
            dy = 0
        elseif dir == "D"
            dx = 0
            dy = -1
        elseif dir == "L"
            dx = -1
            dy = 0
        else
            throw(ArgumentError("invalid direction: $(dir)"))
        end
        x1 = x0 + dx
        y1 = y0 + dy
        #@show (x1,y1)
        push!(point_history,(x1,y1))
        tail_point = update_tail(tail_point,(x1,y1))
        #@show tail_point
        push!(tail_history,tail_point)
        x0 = x1
        y0 = y1
    end
    return (x0,y0),tail_point
end

function update_tail(tail_point,head_point)
    #get the deltas between the tail point and head point
    dx = head_point[1] - tail_point[1]
    dy = head_point[2] - tail_point[2]
    if abs(dx)>1 || abs(dy)>1
        #move tail
        delta_x = 0
        delta_y = 0
        if !(dx==0)
           delta_x = Int(dx/abs(dx))
        end
        if !(dy==0)
            delta_y = Int(dy/abs(dy))
        end
        x_new = tail_point[1]+delta_x
        y_new = tail_point[2]+delta_y
    else
        x_new = tail_point[1]
        y_new = tail_point[2]
    end
    return (x_new,y_new)
end

function run_instructions_2(instructions, size)
    points = Vector{Tuple{Int,Int}}(undef,size)
   
    history = Vector{Set{Tuple{Int,Int}}}(undef,size)

    
    for i in 1:length(points)
        points[i] = (1,1)
        history[i] = Set{Tuple{Int,Int}}()
        push!(history[i],points[i])
    end
    
    for instruction in instructions
        move_rope_2!(points,history,instruction,size)
    #     #start_point = end_point
    end
    return history#,tail_history
end

function move_rope_2!(points,point_history, instruction,size)
    n_steps = instruction.distance
    dir = instruction.direction
    x0 = points[1][1]
    y0 = points[1][2]
    for i in 1:n_steps
        if dir == "U"
            dx = 0
            dy = 1
        elseif dir == "R"
            dx = 1
            dy = 0
        elseif dir == "D"
            dx = 0
            dy = -1
        elseif dir == "L"
            dx = -1
            dy = 0
        else
            throw(ArgumentError("invalid direction: $(dir)"))
        end
        x1 = x0 + dx
        y1 = y0 + dy
        #@show (x1,y1)
        push!(point_history[1],(x1,y1))
        hx = x1
        hy = y1
        for j in 2:size     

            px = points[j][1]
            py = points[j][2]
            new_point = update_tail((px,py),(hx,hy))
            push!(point_history[j],new_point)
            points[j] = new_point
            hx = new_point[1]
            hy = new_point[2]
        end
        # #@show tail_point
        # push!(tail_history,tail_point)
        x0 = x1
        y0 = y1
    end
    points[1] = (x0,y0)
    #return (x0,y0)#,tail_point
end

# function update_tail_2(tail_point,head_point)
#     #get the deltas between the tail point and head point
#     dx = head_point[1] - tail_point[1]
#     dy = head_point[2] - tail_point[2]
#     if abs(dx)>1 || abs(dy)>1
#         #move tail
#         delta_x = 0
#         delta_y = 0
#         if !(dx==0)
#            delta_x = Int(dx/abs(dx))
#         end
#         if !(dy==0)
#             delta_y = Int(dy/abs(dy))
#         end
#         x_new = tail_point[1]+delta_x
#         y_new = tail_point[2]+delta_y
#     else
#         x_new = tail_point[1]
#         y_new = tail_point[2]
#     end
#     return (x_new,y_new)
# end



instructions = read_instructions(lines)
@show instructions

history,tail_history = run_instructions(instructions)
@show history,length(history)
@show tail_history,length(tail_history)

size = 10
history = run_instructions_2(instructions,size)
for i in 1:size
    @show history[i],length(history[i])
end

