-module(webserver_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	erlydtl:compile_dir("templates", templates, [{out_dir,"../ebin/"}]),
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", hello_handler, []}, 
			{"/num", number_handler, []},
			{"/dtl", dtl_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(
		my_http_listener,
		[{port, 8080}],
		#{env => #{dispatch => Dispatch}}
	),
	webserver_sup:start_link().

stop(_State) ->
	ok.
