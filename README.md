packman
=====

An OTP application

Build
-----
    $ sudo setcap 'cap_net_raw=epi cap_net_admin=+pe' /home/ali/.asdf/installs/erlang/26.2.1/erts-14.2.1/bin/beam.smp 
    $ rebar3 compile
