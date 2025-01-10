-module(day4).
-export([solve_part_1/0, solve_part_2/0]).

solve_part_1() ->
    Input = read("input.txt"),
    Matrix = matrix(Input),
    erlang:display(find_horizontal_xmas(Matrix)),
    erlang:display(find_vertical_xmas(Matrix)),
    erlang:display(build_sub_matrix(Matrix, 4, 4)).

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

matrix(Input) ->
    lists:map(fun(X) -> lists:map(fun(Y) -> [Y] end, X) end, string:tokens(Input, "\n")).

find_vertical_xmas(Matrix) ->
    Transposed = transpose(Matrix),
    find_horizontal_xmas(Transposed).

find_horizontal_xmas(Matrix) ->
    lists:foldl(fun(X, Count) -> Count+count_xmas(lists:flatten(X))+count_xmas(lists:flatten(lists:reverse(X))) end, 0, Matrix).

count_xmas(String) ->
    RE = "XMAS",
    case re:run(String, RE, [global, {capture, all, list}]) of
        {match, Matches} -> length(Matches);
        nomatch -> 0
    end.

transpose(Matrix) ->
    {NewMatrix, Rows, Columns} = {[], lists:seq(1,length(Matrix)), lists:seq(1,length(lists:nth(1, Matrix)))},
    lists:foldl(fun(Column, AccX) -> lists:append(AccX, [lists:foldl(fun(Row, AccY) -> lists:append(AccY, [lists:nth(Column, lists:nth(Row, Matrix))]) end, [], Rows)]) end, NewMatrix, Columns).

build_sub_matrix(Matrix, Row, Column) ->
    {StartRow, EndRow, StartCol, EndCol} = {Row-3, Row+3, Column-3, Column+3},
    {RowSequence, ColSequence} = {lists:seq(StartRow, EndRow), lists:seq(StartCol, EndCol)},
    lists:foldl(fun(ColIndex, AccX) -> lists:append(AccX, [lists:foldl(fun(RowIndex, AccY) -> lists:append(AccY, [get_sub_matrix_element(Matrix, RowIndex, ColIndex, Row, Column)]) end, [], RowSequence)]) end, [], ColSequence).

get_sub_matrix_element(Matrix, RowIndex, ColumnIndex, Row, Column) ->
    {ComputedRow, ComputedCol} = {Row-RowIndex, Column-ColumnIndex},
    {RotatedRow, RotatedCol} = get_rotated_coords(Row, Column, ComputedRow, ComputedCol),
    case ( RotatedRow < 1 orelse RotatedRow > length(Matrix) orelse RotatedCol < 1 orelse RotatedCol > length(lists:nth(1, Matrix)) orelse ComputedRow /= Row orelse ComputedCol /= Column) of
        true -> ".";
        false -> {ComputedRow, ComputedCol}
    end.

get_rotated_coords(Row, Column, ComputedRow, ComputedColumn) ->
    if
        (ComputedRow > 0 andalso ComputedColumn > 0) -> {Row, Column-ComputedRow};
        (ComputedRow < 0 andalso ComputedColumn < 0) -> {Row, Column-ComputedRow};
        (ComputedRow < 0 andalso ComputedColumn > 0) -> {Row-ComputedColumn, Column};
        (ComputedRow > 0 andalso ComputedColumn < 0) -> {Row-ComputedColumn, Column};
        true -> {-1, -1}
    end.
