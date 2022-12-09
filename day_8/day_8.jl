f = open("day_8_input.txt","r")
#f = open("test_input.txt","r")
lines = readlines(f)
line_length = length(lines[1])
function count_lines(lines)
    counter = 0
    for line in lines
        counter +=1
    end
    return counter
end

num_lines = count_lines(lines)

function read_tree_data(lines)
    #create and array for the data
    tree_data = Array{Int}(undef,num_lines,line_length)
    for (i,line) in enumerate(lines)
        for (j,height) in enumerate(collect(line))
            tree_data[i,j] = parse(Int,height)
        end
    end
    return tree_data
end

function check_visibility_left!(tree_data,is_visible)
    # loop over each row and check visiblity from the left
    for i in 1:num_lines
        max_so_far = -1
        for j in 1:line_length
            if tree_data[i,j]>max_so_far
                is_visible[i,j] = true
                max_so_far = tree_data[i,j]
            end
        end
    end
end

function check_visibility_right!(tree_data,is_visible)
    # loop over each row and check visiblity from the left
    for i in 1:num_lines
        max_so_far = -1
        for j in line_length:-1:1            
            if tree_data[i,j]>max_so_far
                is_visible[i,j] = true
                max_so_far = tree_data[i,j]
            end
        end
    end
end

function check_visibility_top!(tree_data,is_visible)
    # loop over each row and check visiblity from the left
    for j in 1:line_length
        max_so_far = -1
        for i in 1:num_lines
            if tree_data[i,j]>max_so_far
                is_visible[i,j] = true
                max_so_far = tree_data[i,j]
            end
        end
    end
end

function check_visibility_bottom!(tree_data,is_visible)
    # loop over each row and check visiblity from the left
    for j in 1:line_length
        max_so_far = -1
        for i in num_lines:-1:1
            if tree_data[i,j]>max_so_far
                is_visible[i,j] = true
                max_so_far = tree_data[i,j]
            end
        end
    end
end

function compute_senic_score!(tree_data,senic_score,i1,i2,di,j1,j2,dj)
    tree_tracker = Vector{Int}(undef,10)
    
    # loop over each row and check visiblity from the left
    for i in i1:di:i2
        # max_so_far = -1
        # max_idx = 1
        tree_tracker[:].=j1
        score = 0
        for j in j1:dj:j2
            height_idx = tree_data[i,j] + 1
            closet_blocker = maximum(tree_tracker[height_idx:10].*dj).*dj
            score = abs(j- closet_blocker)
            scenic_score[i,j] = score
            # update the most recent occurance of the current tree height in the tree tracker
            
            tree_tracker[height_idx] = j
        end
    end
end
function compute_senic_score_col!(tree_data,senic_score,i1,i2,di,j1,j2,dj)
    tree_tracker = Vector{Int}(undef,10)
    # loop over each row and check visiblity from the left
    for j in j1:dj:j2
        tree_tracker[:].=i1
        score = 0
        for i in i1:di:i2
            height_idx = tree_data[i,j] + 1
            closet_blocker = maximum(tree_tracker[height_idx:10].*di).*di
            score = abs(i- closet_blocker)
            scenic_score[i,j] = score
            tree_tracker[height_idx] = i
        end
    end
end

function count_visible_tree(is_visible)
    counter = 0
    for i in 1:num_lines
        for j in 1:line_length
            if is_visible[i,j]
                counter+=1
            end
        end
    end
    return counter
end

tree_data = read_tree_data(lines)
is_visible = Array{Bool}(undef,num_lines,line_length)
is_visible[:,:] .= false
total_scenic_score = Array{Int}(undef,num_lines,line_length)
scenic_score = Array{Int}(undef,num_lines,line_length)
total_scenic_score[:,:] .= 1
scenic_score[:,:] .= 0

check_visibility_left!(tree_data,is_visible)
check_visibility_right!(tree_data,is_visible)
check_visibility_top!(tree_data,is_visible)
check_visibility_bottom!(tree_data,is_visible)

num_trees = count_visible_tree(is_visible)
@show num_trees

compute_senic_score!(tree_data,scenic_score,1,num_lines,1,1,line_length,1)
total_scenic_score .*=scenic_score
scenic_score[:,:] .= 0

compute_senic_score!(tree_data,scenic_score,1,num_lines,1,line_length,1,-1)
total_scenic_score .*=scenic_score
scenic_score[:,:] .= 0

compute_senic_score_col!(tree_data,scenic_score,1,num_lines,1,1,line_length,1)
total_scenic_score .*=scenic_score
scenic_score[:,:] .= 0

compute_senic_score_col!(tree_data,scenic_score,num_lines,1,-1,1,line_length,1)
total_scenic_score .*=scenic_score
scenic_score[:,:] .= 0
@show maximum(total_scenic_score)
