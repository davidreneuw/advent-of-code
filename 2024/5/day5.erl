-module(day5).
-export([solve_part_1/0, solve_part_2/0]).

solve_part_1() ->
    Input = read("input.txt"),
    {Rules, Updates} = get_rules_updates_string(Input),
    lists:sum(parse_valid_updates(Updates, Rules)).

solve_part_2() ->
    Input = read("input.txt"),
    {Rules, Updates} = get_rules_updates_string(Input),
    lists:sum(parse_invalid_updates(Updates, Rules)).

parse_valid_updates(Updates, Rules) ->
    Result = lists:foldl(
        fun(X, List) -> 
            [parse_valid_update(X, Rules) | List]
        end, [], Updates),
    Result.

parse_valid_update(Update, Rules) ->
    RulesFor = get_rules_for_update(Update, Rules),
    case verify_rules_against_update(RulesFor, Update) of
        true -> {Int, _} = string:to_integer(get_middle_number_of_update(Update)), Int;
        false -> 0
    end.

parse_invalid_updates(Updates, Rules) ->
    Result = lists:foldl(
        fun(X, List) -> 
            [parse_invalid_update(X, Rules) | List]
        end, [], Updates),
    Result.

parse_invalid_update(Update, Rules) ->
    RulesFor = get_rules_for_update(Update, Rules),
    case verify_rules_against_update(RulesFor, Update) of
        true -> 0;
        false -> {Int, _} = string:to_integer(get_middle_number_of_update(correct_update(Update, Rules))), Int
    end.

correct_update(Update, Rules) ->
    Numbers = string:tokens(Update, ","),
    CorrectedNumbers = correct_numbers(Numbers, Rules),
    lists:flatten(lists:map(fun(X) -> X ++ "," end, CorrectedNumbers)).

parse_rules(Rules) ->
    lists:map(fun(Rule) ->
        [A, B] = string:tokens(Rule, "|"),
        {A, B}
    end, Rules).
    
correct_numbers(Numbers, Rules) ->
    RulePairs = parse_rules(Rules),
    NewNumbers = lists:foldl(fun({A, B}, Acc) ->
        case lists:member(A, Acc) andalso lists:member(B, Acc) of
            true ->
                {IndexA, IndexB} = {index_of(A, Acc), index_of(B, Acc)},
                if IndexA > IndexB ->
                    {Left, Right} = lists:split(IndexB - 1, Acc),
                            NewRight = lists:delete(A, Right),
                            Left ++ [A] ++ NewRight;
                    true -> Acc
                end;
            false -> Acc
        end
    end, Numbers, RulePairs),
    NewUpdate = lists:flatten(lists:map(fun(X) -> X ++ "," end, NewNumbers)),
    case verify_rules_against_update(get_rules_for_update(NewUpdate, Rules), NewUpdate) of
        true -> NewNumbers;
        false -> correct_numbers(NewNumbers, Rules)
    end.

get_middle_number_of_update(Update) ->
    List = string:tokens(Update, ","),
    Length = length(List),
    MiddleIndex = (Length div 2) + 1,
    lists:nth(MiddleIndex, List).

get_rules_for_update(Update, Rules) ->
    Numbers = string:tokens(Update, ","),
    lists:foldl(
        fun(X, List) -> 
            RulesFor = get_rules_for_number(X, Rules),
            lists:append(List, RulesFor)
        end, [], Numbers).

get_rules_for_number(Number, Rules) ->
   lists:foldl(
       fun(X, List) -> 
           case string:str(X, Number) of
               N when N > 0 -> [X | List];
               _ -> List
           end
       end, [], Rules).

verify_rules_against_update(Rules, Update) ->
    Results = lists:foldl(
        fun(X, List) -> 
            [verify_rule_against_update(X, Update) | List]
        end, [], Rules),
    lists:all(fun(X) -> X == true end, Results).

verify_rule_against_update(Rule, Update) ->
    [Before, After] = string:tokens(Rule, "|"),
    UpdateElements = string:tokens(Update, ","),
    case {index_of(Before, UpdateElements), index_of(After, UpdateElements)} of
        {not_found, not_found} -> true;
        {not_found, _} -> true;
        {_, not_found} -> true;
        {A, B} -> A < B
    end.
    
index_of(Element, List) ->
    index_of(Element, List, 1).

index_of(_, [], _) ->
    not_found;
index_of(Element, [Element | _], Index) ->
    Index;
index_of(Element, [_ | Tail], Index) ->
    index_of(Element, Tail, Index + 1).

get_rules_updates_string(Input) ->
    Lines = string:tokens(Input, "\n"),
    Rules = lists:foldl(
                    fun(X, List) -> 
                        case string:str(X, "|") of
                            N when N > 0 -> [X | List];
                            _ -> List
                        end
                    end, [], Lines),
    Updates = lists:foldl(
                    fun(X, List) -> 
                        case string:str(X, ",") of
                            N when N > 0 -> [X | List];
                            _ -> List
                        end
                    end, [], Lines),
    {Rules, Updates}.

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