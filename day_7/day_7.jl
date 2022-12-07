f = open("day_7_input.txt","r")
#f = open("test_input.txt","r")
lines = readlines(f)

mutable struct dir_data
    parent_dir::String
    child_dirs::Vector{String}
    num_subdir::Int
    total_local_file_size::Int
end
#ls_re = r"^(\$)(\s*)([a-z,A-Z]*)"
cd_re = r"^(\$)(\s*)([a-z,A-Z]*)(\s*)([[a-z,A-Z,\..,\/]*)"
dir_re = r"^([a-z,A-Z]*)(\s*)([[a-z,A-Z]*)"
file_re = r"^([0-9]+)(\s*)([[a-z,A-Z]*\.*[a-z,A-Z]*)"

# Parse file to create a dictionary with an entry for each directory with entries for parent dir, subdirs,number of files,, number of subdirs total local file size

# need regular expressions for :
# cd,ls,dir, file
function create_dir_keys(current_dir,new_dir)

    parent_key = create_dir_name(current_dir)
    entry_key = parent_key*new_dir

    return entry_key,parent_key
end

# I need to use the full directory structure as the name
function add_dir!(dir_dict,current_dir,new_dir)
    entry_key,parent_key = create_dir_keys(current_dir,new_dir)
    if !(entry_key in keys(dir_dict))
        dir_entry = dir_data(parent_key,[],0,0)
        #@show "add",entry_key,parent_key
        dir_dict[entry_key] = dir_entry
    else
        println("dir $(entry_key) already exists")
        error()
    end
end

function create_dir_name(dir_array)
    dir_name = ""
    for item in dir_array
        dir_name *=item
    end

    return dir_name
end

function create_directory_dict(lines)
    dir_dict = Dict{String,dir_data}()
    current_dir = Vector{String}()
    new_dir = "/"
    # push!(current_dir,new_dir)
    add_dir!(dir_dict,current_dir,new_dir)
    #is_reading = false
    for line in lines
        #@show line
        #if occursin(cd_re,line)
            #this is a directory change
            cmd_match = match(cd_re,line)
            dir_match = match(dir_re,line)
            file_match = match(file_re,line)
            #@show cmd_match,dir_match,file_match
            if !(isnothing(cmd_match))
                if cmd_match[3]=="cd"
                    #@show cmd_match
                    dir_key = cmd_match[5]
                    if dir_key == ".."
                        pop!(current_dir)
                    else
                        push!(current_dir, dir_key)
                    end
                    #is_reading = false
                # else
                #     #@show "ls",cmd_match
                #     is_reading = true
                end
            elseif !isnothing(file_match)
                #increment file size for current dir
                @show current_dir,file_match
                file_size = parse(Int,file_match[1])
                entry_key,current_key = create_dir_keys(current_dir,"")
                dir_dict[current_key].
                total_local_file_size+=file_size
            elseif !isnothing(dir_match)
                # add a child directory to struct for current dir, and increment dir counter
                @show current_dir,dir_match
                if !(dir_match[3]=="")

                    entry_key,current_key = create_dir_keys(current_dir,dir_match[3])
                    add_dir!(dir_dict,current_dir,dir_match[3])
                    push!(dir_dict[current_key].child_dirs,entry_key)
                    dir_dict[current_key].num_subdir+=1
                end
            else
                println("no line match")
            end
        #end
    end
    return dir_dict
end


function get_dir_size(dir_dict,key)
    file_size = dir_dict[key].total_local_file_size
    if !isempty(dir_dict[key].child_dirs)
        for dir_key in dir_dict[key].child_dirs
            file_size+= get_dir_size(dir_dict,dir_key)
        end
    end
    return file_size
end


function sum_subdirs(dir_dict)
    total_sizes = Dict{String,Int}()
    for key in keys(dir_dict)
        total_sizes[key] = get_dir_size(dir_dict,key)
    end
    
    return total_sizes
end

function threshold_sum(total_sizes,threshold)
    total_size = 0
    for key in keys(total_sizes)
        if total_sizes[key]<threshold
            total_size+=total_sizes[key]
            @show key
        end
    end
    return total_size
end

function threshold_trim(total_sizes,threshold)
    trimmed_sizes = Dict{String,Int}()
    for key in keys(total_sizes)
        if !(total_sizes[key]<threshold)
            trimmed_sizes[key] = total_sizes[key]
            @show key
        end
    end
    return trimmed_sizes
end



dir_dict = create_directory_dict(lines)
@show dir_dict
total_sizes = sum_subdirs(dir_dict)
@show total_sizes
threshold = 100000
total_size = threshold_sum(total_sizes,threshold)
@show total_size

file_system_size = 70000000
required_space = 30000000



current_unused_space = file_system_size - total_sizes["/"]
@show current_unused_space
removal_threshold = required_space-current_unused_space
@show removal_threshold

trimmed_sizes = threshold_trim(total_sizes,removal_threshold)
@show trimmed_sizes,findmin(trimmed_sizes)