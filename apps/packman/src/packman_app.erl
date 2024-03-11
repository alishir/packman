%%%-------------------------------------------------------------------
%% @doc packman public API
%% @end
%%%-------------------------------------------------------------------

-module(packman_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    packman_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
