#ETS(Erlang Term Storage)
#In case our registry is being accessed concurrently by multiple processes,
#the registry may become a bottleneck!

#How to use ETS as a cache mechanism.
#Don't use ETS as a cache prematurely!, Log and analyze your applicatoin performance
#and identify which parts are bottlenecks , so you know whether you should cache, and what you should cache.

#ETS as a cache
#Allows us to store any Elixir term in an in-memory table.
#working with ETS tables is done via Erlang's :ets module

table = :ets.new(:buckets_registry, [:set, :protected])
IO.inspect :ets.insert(table, {"foo", self()})

IO.inspect :ets.lookup(table,"foo")

#note :set -> keys cannot be duplicated, :protected -> only the process that created the table can write to it.
#options access controls=>
# :public -> read/write, :protected -> read, :private -> read/write lited to owner process

#ETS tabls can also be named
:ets.new(:buckets_registry, [:named_table])
IO.inspect :ets.insert(:buckets_registry, {"foo", self()})
IO.inspect :ets.lookup(:buckets_registry, "foo")

#Elixir developers prefer to use call/2 instead of cast/2, using cast/2 when not necessary can also be considered a premature optimization
