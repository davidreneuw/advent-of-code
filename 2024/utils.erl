-module(utils).
-export([read/1, write/2]).

read(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
        after file:close(Device)
    end.

write(FileName, Data) ->
    {ok, Device} = file:open(FileName, [write]),
    try write_lines(Device, Data)
        after file:close(Device)
    end.

write_lines(_, []) -> ok;
write_lines(Device, [Line | Rest]) ->
    io:format(Device, "~s~n", [Line]),
    write_lines(Device, Rest).

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof -> [];
        Line -> Line ++ get_all_lines(Device)
    end.