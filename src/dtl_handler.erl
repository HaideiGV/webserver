-module(dtl_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
    erlydtl:compile_file(
		"templates/index.dtl", 
		index_mod, 
		[{out_dir, "../ebin/"}]
	),
	{ok, [Binary]} = index_mod:render(),
	Req = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/html">>},
		Binary,
		Req0
	),
	{ok, Req, State}.