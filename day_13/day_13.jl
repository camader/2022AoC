f = open("day_13_input.txt","r")
#f = open("test_input.txt","r")
#f = open("test_input_rev.txt","r")
#f = open("test_input_3.txt","r")
#f = open("test_input_4.txt","r")
#f = open("input.txt","r")
lines = readlines(f)

mutable struct Packet
    left::Vector{Any}
    right::Vector{Any}
    sub_packet::Union{Nothing,Packet}
end

function create_packet_list(line)
    # packet_list = []
    #@show line
    chars = collect(line)
    #@show chars
    packet_list = parse_chars!(chars)[1]
    #@show packet_list
    return packet_list
end

function parse_chars!(chars)
    new_list = []
    #@show "entering"
    while length(chars)>0
        char = popfirst!(chars)
        #@show char,chars,new_list
        if char == ','
            continue
        elseif char=='['
            sub_list = parse_chars!(chars)
            push!(new_list,sub_list)
        elseif char==']'
        #@show "returning",new_list
            return new_list
        else
            if chars[1]=='0'
                new_char = popfirst!(chars)
                char*=new_char
            end
            #@show char*chars[1],parse(Int,chars[1])
            push!(new_list,parse(Int,char))
        end
    end
    return new_list
end

function read_packets(lines)
packets = Packet[]
create_packet = true
counter = 0
packet_counter = 0
for line in lines
    if create_packet
        push!(packets,Packet([],[],nothing))
        create_packet=false
        packet_counter+=1
        counter=1
    end
    if !(line=="")
        if counter==1
            
            packet = create_packet_list(line)
            #push!(packets[packet_counter].left,packet)
            packets[packet_counter].left=packet
            counter +=1
        elseif counter==2
            packet = create_packet_list(line)
            #push!(packets[packet_counter].right,packet)
            packets[packet_counter].right = packet
            counter=0
        end
    else
        
        create_packet=true
    end

    #@show line

end
return packets
end

function compare_packets(packets,n_packets)
    is_correct = Vector{Bool}(undef,n_packets)
    for (i,packet) in enumerate(packets)
        #println("== Pair $i ==")
        #@show i, packet.left,packet.right
        is_correct[i] = check_packet(packet.left,packet.right)
    end
    return is_correct
end

function check_packet(left::Vector{<:Any},right::Vector{<:Any})
    n_elem = length(left)
    if length(left)>length(right)
        n_elem = length(right)
    end
    #println("-Compare $left vs $right")
    for i in 1:n_elem
        #@show i, left[i],right[i]
        val =check_packet(left[i],right[i])
        #@show val
        if val==true
            return true
        elseif val==false
            return false
        end
    end

    if length(left)<length(right)
        #println("left side ran out, correct order")
        return true
    elseif length(left)==length(right)
        return "push"
    else
        #println("right side ran out, incorrect order")
        return false
    end
end

function check_packet(left::Vector{<:Any},right::Int)
    #println("-mixed types, convert right to $([right]) and retry")
    right = [right]
    val =check_packet(left,right)
    return val
end

function check_packet(left::Int,right::Vector{<:Any})
    #println("-mixed types, convert left to $([left]) and retry")
    left = [left]
    val =check_packet(left,right)
    return val
end

function check_packet(left::Int,right::Int)
    #println("Compare $left vs $right")
    if left < right
        #println("-Left side is smaller")
        return true
    elseif left == right
        return "push"
    else
        return false
    end
end

function count_indices(is_correct)
    sum = 0
    for (i,val) in enumerate(is_correct)
        if val
            sum +=i
        end
    end
    return sum
end

packets = read_packets(lines)
n_packets = length(packets)
@show packets,n_packets

is_correct = compare_packets(packets,n_packets)
@show is_correct

count = count_indices(is_correct)
@show count

function create_packet_array(packets)
    new_packets = []
    for packet in packets
        push!(new_packets,packet.left)
        push!(new_packets,packet.right)
    end
    push!(new_packets,[[2]]) 
    push!(new_packets,[[6]])
    return new_packets
end

packet_array = create_packet_array(packets)
#@show packet_array

p = sortperm(packet_array; lt = check_packet)
i1 = length(packet_array)
i2 = length(packet_array)-1
#@show p
#@show packet_array[p]

decoder =  only(findall(x->x==i1, p))*only(findall(x->x==i2, p))
@show decoder