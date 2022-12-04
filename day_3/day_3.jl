
f = open("day3_input.txt","r")
lines = readlines(f)

function create_groups(lines)
    group_list = []
    elves = String[]
    counter = 1
    for line in lines
        push!(elves,line)
        counter+=1
        if counter==4
            push!(group_list,elves)
            elves = String[]
            counter=1
        end
    end
    return group_list

end

function sort_items(lines)
    priority = create_priority_dict()
    sum = 0
    for line in lines
       matching_item = find_matching_item(line)
       sum += priority[matching_item]
    end
    return sum
end

function find_matching_item(line)
    pack_1 = Dict{Char,Int}()
    pack_2 = Dict{Char,Int}()
    split_marker = length(line)/2
    for (i,item) in enumerate(line)
        if i<= split_marker
            pack_1[item] = 1
        else
            pack_2[item] = 1
        end
    end
    for key in keys(pack_1)
        if key in keys(pack_2)
            return key
        end
    end
    println("no match found")

end

function create_priority_dict()
    priority = Dict{Char,Int}()
    for (i,item) in enumerate('a':'z')
        priority[item] = i
    end
    for (i,item) in enumerate('A':'Z')
        priority[item] = i + 26
    end
    return priority
end

function find_group_item(group)
    elves = Vector{Dict{Char,Int}}(undef,3)
    for (i,elf) in enumerate(group)
        elves[i]= Dict{Char,Int}()
        for item in elf
            elves[i][item]=1
        end
    end
    for key in keys(elves[1])
        if (key in keys(elves[2]))&&(key in keys(elves[3]))
            return key
        end
    end
    println("no match found")
end

function get_badge_sum(lines)
    priority = create_priority_dict()
    sum = 0
    group_list = create_groups(lines)
    for group in group_list
        matching_item = find_group_item(group)
        sum += priority[matching_item]
    end
   
    return sum
end

total = sort_items(lines)
@show total

badge_total = get_badge_sum(lines)
@show badge_total