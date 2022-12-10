f = open("day_10_input.txt","r")
#f = open("test_input_2.txt","r")
#f = open("test_input_1.txt","r")
lines = readlines(f)

struct Instruction
    name::String
    distance::Int
end



function read_instructions(lines)
    instructions = Vector{Instruction}()
    for line in lines
        if occursin("noop", line)
            tmp = Instruction(line,0)
        else
            vals = split(line)
            tmp = Instruction(vals[1],parse(Int,vals[2]))
        end
        push!(instructions,tmp)
    end
    return instructions
end

function run_instructions(instructions)
    x_hist = Int[]
    x = 1
    for instruction in instructions
        if instruction.name=="noop"
            x = noop!(x,x_hist)
        elseif instruction.name == "addx"
            x = addx!(x,x_hist,instruction.distance)
        else
            throw(ArgumentError("invalid instruction $(instruction.name)"))
        end
    end
    return x_hist

end

function noop!(x,x_hist)
    push!(x_hist,x)
    return x
end
function addx!(x,x_hist,dx)
    push!(x_hist,x)
    push!(x_hist,x)
    x += dx
    return x
end

function print_strength(x_hist,start_idx,stride)
    sum = 0
    for i in start_idx:stride:length(x_hist)
        @show i,x_hist[i],x_hist[i]*i
        sum += x_hist[i]*i
    end
    return sum
end

function print_letters(x_hist,line_length)
    counter = 0
    for i in 1:length(x_hist)
        lower = x_hist[i]-1
        upper = x_hist[i]+1
        #@show counter,lower, upper, x_hist[i]
        if lower <= counter <= upper
            print("#")
        else
            print(".")
        end
        counter +=1
        if counter == line_length
            print("\n")
            counter = 0
        end
    end
end


instructions = read_instructions(lines)
#@show instructions

x_hist = run_instructions(instructions)
#@show x_hist

print_strength(x_hist,20,40)
print_letters(x_hist,40)