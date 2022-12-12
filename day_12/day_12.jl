using Graphs
f = open("day_12_input.txt","r")
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

function read_height_data(lines)
    #create and array for the data
    height_data = Array{Char}(undef,num_lines,line_length)
    S_loc = (0,0)
    E_loc = (0,0)
    for (i,line) in enumerate(lines)
        for (j,height) in enumerate(collect(line))
            height_data[i,j] = height#parse(Int,height)
            #@show i,j,height
            if height == 'S'
                S_loc = (i,j)
            end
            if height == 'E'
                E_loc = (i,j)
            end
        end
    end
    return height_data,S_loc,E_loc
end

function create_alphanumeric_mapping()
    mapping = Dict{Char,Int}()
    for (i,item) in enumerate('a':'z')
        mapping[item] = i
    end
    mapping['S'] = 0
    mapping['E'] = 27
  
    return mapping
end

function get_node_idx(i,j)
    idx = (i-1)*(line_length)+j
    #@show idx,i,j
    return idx
end



function create_height_graph(height_data)
    n_nodes = num_lines * line_length
    g = DiGraph(n_nodes)
    for i in 1:(num_lines)
        for j in 1:(line_length)
            #@show i,j,height_data[i,j]
            h = mapping[height_data[i,j]]
            
           
            #@show i,j,h,hip,hjp
            if i<num_lines
                hip = mapping[height_data[i+1,j]]
                if (hip-h)<=1
                    #@show "add_edge",get_node_idx(i,j), get_node_idx(i+1,j)
                    add_edge!(g, get_node_idx(i,j), get_node_idx(i+1,j))
                end
            end
            if i>1
                him = mapping[height_data[i-1,j]]
                if (him-h)<=1
                    #@show "add_edge",get_node_idx(i,j), get_node_idx(i+1,j)
                    add_edge!(g, get_node_idx(i,j), get_node_idx(i-1,j))
                end
            end
            if j < line_length
                hjp = mapping[height_data[i,j+1]]
                # if i==10 && j==138
                #     @show i,j,h,hjp,abs(h-hjp),height_data[i,j],height_data[i,j+1]
                #     error()
                # end

                if (hjp-h)<=1
                    #@show "add_edge",get_node_idx(i,j), get_node_idx(i,j+1)
                    add_edge!(g, get_node_idx(i,j), get_node_idx(i,j+1))
                end
            end
            if j > 1
                hjm = mapping[height_data[i,j-1]]
                # if i==10 && j==138
                #     @show i,j,h,hjp,abs(h-hjp),height_data[i,j],height_data[i,j+1]
                #     error()
                # end

                if (hjm-h)<=1
                    #@show "add_edge",get_node_idx(i,j), get_node_idx(i,j+1)
                    add_edge!(g, get_node_idx(i,j), get_node_idx(i,j-1))
                end
            end
        end
    end
    return g
end

function get_path_length(g,s_node,e_node)
    # s_node = get_node_idx(S_loc[1],S_loc[2])
    # @show s_node
    ds = dijkstra_shortest_paths(g, s_node)
    #@show ds.dists
    # i1 = 10
    # j1 = 139
    # node = get_node_idx(E_loc[1],E_loc[2])#(i1,j1)#
    #@show height_data[i1,j1],get_node_idx(i1,j1)
    #@show node
    counter = 0
    for path in enumerate_paths(ds,e_node)
        #@show counter,path
        counter +=1
    end
    counter -=1
    return counter
end

height_data,S_loc,E_loc = read_height_data(lines)
@show height_data,size(height_data),S_loc,E_loc, num_lines,line_length

mapping = create_alphanumeric_mapping()

g = create_height_graph(height_data)
# @show g,nv(g),ne(g)
# for v in vertices(g)
#     println("vertex $v")
# end

# for e in edges(g)
#     u, v = src(e), dst(e)
#     println("edge $u - $v")
# end
s_node = get_node_idx(S_loc[1],S_loc[2])
e_node = get_node_idx(E_loc[1],E_loc[2])
path_length = get_path_length(g,s_node,e_node)
@show path_length
function get_min_path(g,e_node)
    min_path = Inf
    for i in 1:num_lines
        for j in 1:line_length
            s_node = get_node_idx(i,j)
            height = height_data[i,j]
            if height == 'a'
                path_length = get_path_length(g,s_node,e_node)
                if path_length < min_path && !(path_length==-1)
                    @show path_length,min_path
                    min_path = path_length
                end
            end
        end
    end
    return min_path
end

min_path = get_min_path(g,e_node)
@show min_path
                