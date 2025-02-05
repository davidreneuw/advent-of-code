-module(day7).
-export([solve_part_1/0, solve_part_2/0]).

solve_part_1() ->
    Equations = parse_input(),
    EvaluatedOperations = evaluate_equations_validity_part_1(Equations),
    erlang:display(lists:sum(EvaluatedOperations)).

solve_part_2() ->
    erlang:display("Hello World!").

evaluate_equations_validity_part_1(Equations) ->
    lists:map(fun({Total, Terms}) -> iterate_01_operators(Total, Terms) end, Equations).

iterate_01_operators(Total, Terms) ->
    OperatorCombos = get_01_combinations(length(Terms)-1),
    Results = lists:map(fun(Operators) -> verify_equation(Total, Terms, Operators) end, OperatorCombos),
    Pred = fun(X) -> X == false end,
    case lists:all(Pred, Results) of
        true -> 0;
        false -> Total
    end.

iterate_012_operators(Total, Terms) ->
    OperatorCombos = get_012_combinations(length(Terms)-1),
    Results = lists:map(fun(Operators) -> verify_equation(Total, Terms, Operators) end, OperatorCombos),
    Pred = fun(X) -> X == false end,
    case lists:all(Pred, Results) of
        true -> 0;
        false -> Total
    end.

parse_input() ->
    Input = read("input.txt"),
    Lines = string:tokens(Input, "\n"),
    lists:map(
        fun(Line) ->
            TotalAndTerms = string:split(Line, ":"),
            {Total, _} = string:to_integer(lists:nth(1, TotalAndTerms)),
            Terms = lists:map(
                fun(Term) ->
                    {TermInt, _} = string:to_integer(Term),
                    TermInt
                end,
                string:tokens(lists:nth(2, TotalAndTerms), " ")
            ),
            {Total, Terms}
        end,
        Lines
    ).

verify_equation(Total, Terms, Operators) ->
    Indexes = lists:seq(1, length(Terms)-1),
    CalculatedTotal = lists:foldl(fun(Index, CurrTotal) -> 
        case lists:nth(Index, Operators) of
            0 -> CurrTotal * lists:nth(Index+1, Terms);
            1 -> CurrTotal + lists:nth(Index+1, Terms);
        end end, lists:nth(1, Terms), Indexes),
    case Total == CalculatedTotal of
        true -> CalculatedTotal;
        false -> false
    end.

parse_concats(Terms, Operators) ->
    NewOperators = lists:filter(fun(X) -> X =/= 2 end, Operators),
    TwoIndexes = get_indexes(2, Operators),
    lists:foreach(fun(Index) ->
        {Term1, Term2} = {lists:nth(Index, Terms), lists:nth(Index, Terms)},
        {TermString1, TermString2} = {integer_to_list(Term1), integer_to_list(Term2)},
        NewTerm = TermString1+TermString2,
        lists:delete(Term1, Terms),
        lists:delete(Term2, Terms),
        l TwoIndexes)


get_01_combinations(L) ->
    get_01_combinations(L, []).

get_01_combinations(0, Acc) ->
    [lists:reverse(Acc)];
get_01_combinations(L, Acc) ->
    get_01_combinations(L - 1, [0 | Acc]) ++ get_01_combinations(L - 1, [1 | Acc]).

get_012_combinations(L) ->
    get_012_combinations(L, []).

get_012_combinations(0, Acc) ->
    [lists:reverse(Acc)];
get_012_combinations(L, Acc) ->
    get_012_combinations(L - 1, [0 | Acc]) ++ get_012_combinations(L - 1, [1 | Acc]) ++ get_012_combinations(L - 1, [2 | Acc]).

get_indexes(Element, List) ->
    get_indexes(Element, List, 1, []).

get_indexes(_, [], _, Acc) ->
    lists:reverse(Acc);
get_indexes(Element, [Element | T], Index, Acc) ->
    get_indexes(Element, T, Index + 1, [Index | Acc]);
get_indexes(Element, [_ | T], Index, Acc) ->
    get_indexes(Element, T, Index + 1, Acc).


read(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try
        get_all_lines(Device)
    after
        file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof -> [];
        Line -> Line ++ get_all_lines(Device)
    end.
