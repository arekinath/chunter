-module(zone_vfs).

-export([zone_vfs/1]).

zone_vfs({KStat, Acc}) ->
    Data = ekstat:read(KStat, "zone_vfs", "zone_vfs"),
    Data1 = [Keys || {_,_,_ID,_, Keys} <- Data, _ID =/= 0],
    {KStat, build_obj(Data1, Acc)}.

build_obj([Keys | R], Data) ->
    UUID = list_to_binary(proplists:get_value("zonename", Keys)),
    Statistics = lists:foldl(fun({"zonename", _}, Obj) ->
                                     Obj;
                                ({K, V}, Obj) ->
                                     jsxd:set([list_to_binary(K)], V, Obj)
                             end, [], Keys),
    Data1 = [{UUID, [{<<"data">>, Statistics},
                     {<<"event">>, <<"vfs">>}]}|Data],
    build_obj(R, Data1);

build_obj([], Data) ->
    Data.
