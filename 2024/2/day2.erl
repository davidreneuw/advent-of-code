%%% Solved part 1, then broke it so hard in an attempt to solve part 2, then gave up
-module(day2).
-export([solve_part_1/0, solve_part_2/0]).

solve_part_1() ->
    Data = read("input.txt"),
    Reports= lists:map(fun(X) -> X end, string:tokens(Data, "\n")),
    TotalSafe = evaluate_safety(Reports),
    erlang:display(TotalSafe).

solve_part_2() ->
    erlang:display("Hello world!").

read(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
        after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

evaluate_safety(List) ->
    lists:foldl(
        fun(X, Count) -> 
            case check_safety(X) of
                true -> Count + 1;
                false -> Count
            end
        end, 0, List).

check_safety(Report) ->
    Levels = lists:map(fun(X) -> {Int, _} = string:to_integer(X), Int end, string:tokens(Report, " ")),
    check_levels_safety(Levels).
    
check_levels_safety(List) ->
    check_levels_safety(List, true, 0).

check_levels_safety(_, false, _, _) ->
    false;
check_levels_safety(_, _, _, Errors) when Errors > 1 ->
    false;
check_levels_safety([], true, _, _) ->
    true;
check_levels_safety(List, Index, Safe, Direction, Errors) ->
    {[First | _], Last} = {List, lists:last(List)},
    Element = lists:nth(Index, List),
    if
        (Element == First) -> {Level1, Level2, Level3} = {0, Element, lists:nth(Index+1, List)};
        (Element == Last) -> {Level1, Level2, Level3} = {lists:nth(Index-1, List), Element, 0};
        true -> {Level1, Level2, Level3} = {lists:nth(Index-1, List), Element, lists:nth(Index+1, List)}
    end
    {LevelSafe, NewDirection} = compare_levels(H1, H2, Direction),
    case LevelSafe of
        true -> check_levels_safety([H2 | T], Safe, NewDirection, Errors);
        false -> 
    
compare_levels(Level1, Level2, Level3, Direction) ->
    Difference12 = Level2-Level1,
    Direction12 = Difference12/abs(Difference12),
    Difference23 = Level3-Level2,
    Direction23 = Difference23/abs(Difference23),
    Difference13 = Level3-Level1,
    Dire
    {Difference >= 1 and Difference <=3 and (Direction == 0 or NewDirection == Direction), NewDirection}.

   
    
    
    


    
    