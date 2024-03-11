-module(capture).

-export([handle_continue/2]).
-behaviour(gen_server).

%% Callbacks for `gen_server`
-export([init/1, handle_call/3, handle_cast/2]).

-export([start_link/0]).

-include_lib("kernel/include/logger.hrl").

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_Args) ->
    ?LOG_INFO("started ..."),
    {ok, Socket} = socket:open(17, 2, 768),
    {ok, IfIndex} = socket:ioctl(Socket, gifindex, "wlp2s0"),
    ?LOG_INFO("index: ~p~n", [IfIndex]),

    % did not work
    ok = socket:bind(Socket, #{
        family => packet,
        protocol => 768,
        ifindex => 3,
        pkttype => host,
        hatype => ether,
        addr => <<>>
        % addr => {16#05, 16#25, 16#67, 16#f8, 16#28, 16#00}
        % addr => {16#00, 16#28, 16#f8, 16#67, 16#25, 16#05}
        % addr => <<16#05, 16#25, 16#67, 16#f8, 16#28, 16#00>>
        % addr => <<"05:25:67:f8:28:00">>
        % addr => <<"00:28:f8:67:25:05">>
        % addr => <<16#00, 16#28, 16#f8, 16#67, 16#25, 16#05>>
        % addr => <<16#0028f86725050000:64/big>>
        % addr => <<0>>
    }),
    {ok, #{recv_sock => Socket}, {continue, read_packets}}.

handle_continue(read_packets, #{recv_sock := Socket} = State) ->
    ?LOG_INFO("reading packets ...."),
    % check if we have any received packet or not
    case socket:recvfrom(Socket, 0, 500) of
        {ok, Data} ->
            ?LOG_INFO("recv packet ~p~n", [Data]);
        Val ->
            ?LOG_ERROR("some error --- ~p~n", [Val])
    end,
    {noreply, State, {continue, read_packets}}.
handle_call(Request, From, State) ->
    erlang:error(not_implemented).

handle_cast(Request, State) ->
    erlang:error(not_implemented).
