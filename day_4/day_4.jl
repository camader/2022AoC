##
# Read in the file
# Translate each line into two sets
# perform the union of the two sets and see if the union is equal to either of the original sets.
# if the union is the same as the original, one set is fully contained in the other.


f = open("input.txt","r")
lines = readlines(f)

function get_set_from_range(range)
    start_info = split(range,"-")
    start_idx = parse(Int,String(start_info[1]))
    end_idx = parse(Int,String(start_info[2]))
    #@show start_idx,end_idx

    values = Set()
    for i in start_idx:end_idx
        push!(values,i)
    end
    #@show values
    return values
end

function count_contained(lines)

    contained_counter = 0
    for line in lines
        #@show split(line,",")
        range_info= split(line,",")
        range1 = String(range_info[1])
        range2 = String(range_info[2])
        set1 = get_set_from_range(range1)
        set2 = get_set_from_range(range2)

        set3 = union(set1,set2)
        #@show set3==set1,set3==set2
        if(set3==set1||set3==set2)
            contained_counter+=1
        end
        # start_info = split(range1,"-")
        # @show start_info
        # start1 = String(start_info[1])
        # end1 = String(start_info[2])


        #@show range1,start1,end1
    end

    return contained_counter
end

function count_overlapping(lines)

    overlap_counter = 0
    for line in lines
        #@show split(line,",")
        range_info= split(line,",")
        range1 = String(range_info[1])
        range2 = String(range_info[2])
        set1 = get_set_from_range(range1)
        set2 = get_set_from_range(range2)

        set3 = setdiff(set1,set2)
        if !(set3==set1)
            #@show set1
            overlap_counter+=1
        end
        
    end

    return overlap_counter
end

count = count_contained(lines)
@show count

over_count = count_overlapping(lines)
@show over_count