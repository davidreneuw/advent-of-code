-module(day1).
-export([solve_part_1/0, solve_part_2/0]).
-import(string, [tokens/2]).

solve_part_1() ->
    Data = read("input.txt"),
    Ints = lists:map(fun(X) -> {Int, _} = string:to_integer(X), Int end, string:tokens(Data, " \n")),
    {EvenList, OddList} = split_even_odd(Ints),
    {SortedEven, SortedOdd} = {lists:sort(EvenList), lists:sort(OddList)},
    Difference = normalized_difference(SortedEven, SortedOdd),
    io:format("Difference: ~p~n", [Difference]).

solve_part_2() ->
    Data = read("input.txt"),
    Ints = lists:map(fun(X) -> {Int, _} = string:to_integer(X), Int end, string:tokens(Data, " \n")),
    {EvenList, OddList} = split_even_odd(Ints),
    Similarity = similarity_score(EvenList, OddList),
    io:format("Similarity: ~p~n", [Similarity]).


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

split_even_odd(List) ->
    split_even_odd(List, 0, [], []).

split_even_odd([], _, EvenAcc, OddAcc) ->
    {lists:reverse(EvenAcc), lists:reverse(OddAcc)};
split_even_odd([H | T], Index, EvenAcc, OddAcc) ->
    case Index rem 2 of
        0 -> split_even_odd(T, Index + 1, [H | EvenAcc], OddAcc);
        1 -> split_even_odd(T, Index + 1, EvenAcc, [H | OddAcc])
    end.

normalized_difference(List1, List2) ->
    lists:sum(lists:map(fun({X, Y}) -> abs(X - Y) end, lists:zip(List1, List2))).

similarity_score(List1, List2) ->
    OccurenceList = occurence_list(List1, List2),
    AppliedSimilarity = apply_similarity(List1, OccurenceList),
    lists:sum(AppliedSimilarity).

apply_similarity(List1, List2) ->
    lists:map(
        fun({X, Y}) -> X*Y end, lists:zip(List1, List2)).

occurence_list(List1, List2) ->
    lists:map(
        fun(X) -> count_occurences(List2, X) end, List1).

count_occurences(List, Value) ->
    lists:foldl(
        fun(X, Count) ->
            case X == Value of
                true -> Count + 1;
                false -> Count 
            end 
        end, 0, List).




