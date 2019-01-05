-module(number_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0=#{method := <<"GET">>}, State) ->
	Req = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>},
		<<"99999999999999">>,
		Req0
	),
	{ok, Req, State};

init(Req0=#{method := <<"POST">>}, State) ->
	{ok, Data, _} = cowboy_req:read_body(Req0),
	{DataResult} = jiffy:decode(Data),
	{_, Value} = lists:last(DataResult),
	Result = erlang:integer_to_binary(Value * Value),
	Req = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>}, 
		Result, 
		Req0
	),
	{ok, Req, State};

init(Req0=#{method := <<_>>}, State) ->
	Req = cowboy_req:reply(405,
		#{<<"content-type">> => <<"text/plain">>},
		<<"Method not alowed">>,
		Req0
	),
	{ok, Req, State}.
