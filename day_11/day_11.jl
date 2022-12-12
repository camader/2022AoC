using DataStructures
#f = open("day_11_input.txt","r")
f = open("test_input.txt","r")
lines = readlines(f)


mutable struct Monkey
    items::Queue{Int64}
    op_type::String
    op_value::String
    test_value::Int64
    test_true::Int64
    test_false::Int64
    throw_count::Int64
    worry_divisor::Int64
end

function read_monkeys(lines,divisor)
    monkeys = Vector{Monkey}()
    current_monkey=0
    for line in lines
        if occursin("Monkey",line)
            #@show line
            monkey = Monkey(Queue{Int64}(),"","",0,0,0,0,divisor)
            push!(monkeys,monkey)
            current_monkey +=1
        elseif occursin("Starting items:",line)
            vals1 = split(line,":")
            #@show typeof(vals1[2]),String(vals1[2])
            vals2 = split(String(vals1[2]),",")
            for item in vals2
                #@show vals2
                enqueue!(monkeys[current_monkey].items,parse(Int64,item))
            end
        elseif occursin("Operation:",line)
            vals1 = split(line,"=")
            #@show vals1
            vals2 = split(String(vals1[2]))
            #@show vals2
            monkeys[current_monkey].op_type = vals2[2]
            monkeys[current_monkey].op_value = vals2[3]
        elseif occursin("Test:",line)
            vals1 = split(line)
            monkeys[current_monkey].test_value = parse(Int64,vals1[4])
        #     @show line
        elseif occursin("If true",line)
            vals1 = split(line)
            monkeys[current_monkey].test_true = parse(Int64,vals1[6])
        #     @show line
        elseif occursin("If false",line)
            vals1 = split(line)
            monkeys[current_monkey].test_false = parse(Int64,vals1[6])
        #     @show line
        end
    end
    return monkeys
end

function check_worry(monkey)
    item = dequeue!(monkey.items)
    op = monkey.op_type
    if monkey.op_value == "old"
        val = item
    else
        val = parse(Int64,monkey.op_value)
    end
    if op == "*"
        worry = item * val
    elseif op == "+"    
        worry = item + val
    else
            throw(ArgumentError("invalid_op"))
    end
    @show worry
    #worry = floor(Int64,(worry/3))
    #worry = floor(Int64,sqrt(worry))+floor(Int64,worry/5)
    #worry = mod(worry,9699690)
    worry = mod(worry,96577)
    #worry = floor(Int64,(worry/monkey.worry_divisor))#-monkey.worry_divisor
    #worry = ceil(Int64,(worry/monkey.worry_divisor))-monkey.worry_divisor
    #worry = worry-monkey.worry_divisor
    #worry = worry+monkey.worry_divisor
    #worry = worry * monkey.worry_divisor+monkey.worry_divisor
    #@show worry
    return worry
end
function monkey_turn(monkey)
    #inspect item
    #increas worry
    #reduce worry
    worry = check_worry(monkey)
    #test worry
    test_value = mod(worry,monkey.test_value)
    @show test_value,worry,monkey.test_value#,floor(Int64,sqrt(worry))

    if test_value == 0
        throw_to = monkey.test_true
    else
        throw_to = monkey.test_false
    end
    #throw
    return worry, throw_to
end

function monkey_round!(monkeys)
    for (n,monkey) in enumerate(monkeys)
        for i in 1:length(monkey.items)
            worry,throw_to = monkey_turn(monkey)
            monkey.throw_count +=1
            @show n,worry,throw_to
            enqueue!(monkeys[throw_to+1].items,worry)
        end
    end
end

function run_rounds!(monkeys,n_rounds)
    for i in 1:n_rounds
        monkey_round!(monkeys)
    end
end

function get_max_score(monkeys,levels)
    throw_count = Int64[]
    for monkey in monkeys
        push!(throw_count,monkey.throw_count)
    end
    @show throw_count
    sort!(throw_count,rev=true)
    #@show(throw_count)
    monkey_business = 1
    for i in 1:levels
        monkey_business*=throw_count[i]
    end
    return monkey_business
end


monkeys = read_monkeys(lines,3)
#@show monkeys

# monkey_round!(monkeys)
# @show monkeys
n_rounds = 10000
run_rounds!(monkeys,n_rounds)
#@show monkeys

monkey_business = get_max_score(monkeys,2)
@show monkey_business