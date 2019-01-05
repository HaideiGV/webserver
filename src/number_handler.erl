-module(number_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0=#{method := <<"GET">>}, State) ->
	io:fwrite(">> POST REQUEST >> ~n~w~n", Req0),
	Req = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>},
		<<100, 101, 102, 103>>,
		Req0
	),
	{ok, Req, State};

init(Req0=#{method := <<"POST">>}, State) ->
	{ok, Data, _} = cowboy_req:read_body(Req0),
	{DataResult} = jiffy:decode(Data),
	{_, Value} = lists:last(DataResult),
	io:fwrite(">> IS INT >> ~n~w~n", [erlang:is_integer(Value)]),
	io:fwrite(">> IS BINARY >> ~n~w~n", [erlang:is_binary(Value)]),
	Result = erlang:integer_to_binary(Value * Value),
	io:fwrite(">> REQUEST >> ~n~w~n", [Result]),
	Req = cowboy_req:reply(200, #{<<"content-type">> => <<"text/plain">>}, Result, Req0),
	{ok, Req, State};

init(Req0=#{method := <<_>>}, State) ->
	io:fwrite(">> OTHER REQUEST >> ~n~w~n", [Req0]),
	Req = cowboy_req:reply(405,
		#{<<"content-type">> => <<"text/plain">>},
		<<"Method not alowed">>,
		Req0
	),
	{ok, Req, State}.
