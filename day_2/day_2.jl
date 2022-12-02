
function round_score(
    opponent::String,
    player::String
)
    outcomes = Dict{String,Int}()
    outcomes["win"] = 6
    outcomes["draw"] = 3
    outcomes["lose"] = 0

    score = selection_score(player)
    score += outcome(opponent,player,outcomes)

    return score
end

function round_score_2(
    opponent::String,
    player::String
)
    outcomes = Dict{String,Int}()
    outcomes["win"] = 6
    outcomes["draw"] = 3
    outcomes["lose"] = 0

   
    player = player_selection(opponent,player)
    
    score = selection_score(player)
    score += outcome(opponent,player,outcomes)

    return score
end

function selection_score(
    player::String
)
    if player == "X" #rock
        return 1
    elseif player == "Y" #Paper
        return 2
    elseif player == "Z" # Scissors
        return 3
    else
        throw(ArgumentError("incorrect input to selection score $(player)"))
    end
end

function outcome(
    opponent::String,
    player::String,
    outcomes
)

    if opponent == "A" #Rock
        if player == "X" #rock
            return outcomes["draw"]
        elseif player == "Y" #paper
            return outcomes["win"]
        elseif player == "Z" #Scissors
            return outcomes["lose"]
        end
    elseif opponent == "B" #Paper
        if player == "X" #rock
            return outcomes["lose"]
        elseif player == "Y" #paper
            return outcomes["draw"]
        elseif player == "Z" #Scissors
            return outcomes["win"]
        end
    elseif opponent == "C" #Scissors
        if player == "X" #rock
            return outcomes["win"]
        elseif player == "Y" #paper
            return outcomes["lose"]
        elseif player == "Z" #Scissors
            return outcomes["draw"]
        end
    end
    throw(ArgumentError("invalid input combination $(opponent),$(player)"))
end

function player_selection(
    opponent::String,
    player::String,
)

    if opponent == "A" #Rock
        if player == "X" #lose
            return "Z" #Scissors
        elseif player == "Y" #draw
            return "X" #rock
        elseif player == "Z" #win
            return "Y" #Paper
        end
    elseif opponent == "B" #Paper
        if player == "X" #lose
            return "X" #rock
        elseif player == "Y" #draw
            return "Y" #paper
        elseif player == "Z" #win
            return "Z" #Scissors
        end
    elseif opponent == "C" #Scissors
        if player == "X" #lose
            return "Y" #paper
        elseif player == "Y" #draw
            return "Z" #Scissors
        elseif player == "Z" #win
            return "X" #rock
        end
    end
    throw(ArgumentError("invalid input combination $(opponent),$(player)"))
end


function compute_score(lines)
    score = 0
    for line in lines
        round_info = split(line," ")
        opponent = String(round_info[1])
        player = String(round_info[2])
        score += round_score(opponent,player)
    end
    return score
end

function compute_score_2(lines)
    score = 0
    for line in lines
        round_info = split(line," ")
        opponent = String(round_info[1])
        player = String(round_info[2])
        score += round_score_2(opponent,player)
    end
    return score
end

f = open("input.txt","r")
lines = readlines(f)

@show compute_score(lines)

@show compute_score_2(lines)