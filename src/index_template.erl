-module(index_template).
-export([page/0]).

page() ->
    <<"<html>
        <body>
            <h1>
                HELLO ERLANG TEMPLATE VIA BINARY
            </h1>
        </body>
    </html>">>.