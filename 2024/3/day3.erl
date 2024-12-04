-module(day3).
-export([solve_part_1/0, solve_part_2/0]).

solve_part_1() ->
    MulRegExp = "mul\\([0-9]{1,3}+,[0-9]{1,3}+\\)", %Regex to match all mul(X,Y) patterns
    Input = read("input.txt"),
    case re:run(Input, MulRegExp, [global, {capture, all, list}]) of
        {match, Matches} -> lists:foldl(fun(X, Total) -> parse_mul(X)+Total end, 0, Matches);
        nomatch -> erlang:display("No match found")
    end.

solve_part_2() ->
    MulRegExp = "mul\\([0-9]{1,3}+,[0-9]{1,3}+\\)", %Regex to match all mul(X,Y) patterns
    DoDontRegExp = "don't\\(\\).*?do\\(\\)|don't\\(\\).*\\Z", %Regex to match the shortest don't()<...>do() patterns, which we remove from the string
    Input = read("input.txt"),
    {_, DontDoMatches} = re:run(Input, DoDontRegExp, [global, {capture, all, list}, dotall]),
    CleanInput = lists:foldl(fun(X, Text) -> string:replace(Text, X, "") end, Input, DontDoMatches),
    case re:run(CleanInput, MulRegExp, [global, {capture, all, list}]) of
        {match, Matches} -> lists:foldl(fun(X, Total) -> parse_mul(X)+Total end, 0, Matches);
        nomatch -> erlang:display("No match found")
    end.
    
parse_mul(Match) ->
    RegExp = "[0-9]{1,3}",
    Value = lists:nth(1, Match),
    case re:run(Value, RegExp, [global, {capture, all, list}]) of
        {match, Matches} -> {Int1, _} = string:to_integer(lists:nth(1, Matches)),
                            {Int2, _} = string:to_integer(lists:nth(2, Matches)),
                            Int1*Int2;
        nomatch -> erlang:display("No match found")
    end.

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