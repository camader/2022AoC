function check_for_marker(line,size)
    line_array = collect(line)
    n_chars = length(line_array)
    for i in 1:n_chars-(size-1)
        test_set= Set(line_array[i:i+(size-1)])
        #@show test_set,line_array[i:i+(size-1)],length(test_set)
        if length(test_set)==size
            #@show i,length(test_set)
            return i+size-1
        end
    end
end


f = open("day6_input.txt","r")
#f = open("test_input_1.txt","r")
lines = readlines(f)
for line in lines
    # line_array = collect(line)
    # @show line_array
    idx = check_for_marker(line,4)
    @show idx
    idx2 = check_for_marker(line,14)
    @show idx2
end
