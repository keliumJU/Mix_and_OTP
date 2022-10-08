#supervisors
#error out iex -S mix shell -> IO.inspect KV.Registry.child_spec([])

defmodule Documentation do
@moduledoc """

iex> {:ok, sup} = KV.Supervisor.start_link([])
{:ok, #PID<0.148.0>}
iex> Supervisor.which_children(sup)
[{KV.Registry, #PID<0.150.0>, :worker, [KV.Registry]}]
#Note: Once the supervisor started, it also started all of its children

#Intentionally crash the registry started by the supervisor
iex> [{_, registry, _, _}] = Supervisor.which_children(sup)
[{KV.Registry, #PID<0.150.0>, :worker, [KV.Registry]}]
iex> GenServer.call(registry, :bad_input)
08:52:57.311 [error] GenServer KV.Registry terminating
** (FunctionClauseError) no function clause matching in KV.Registry.handle_call/3
iex> Supervisor.which_children(sup)
[{KV.Registry, #PID<0.157.0>, :worker, [KV.Registry]}]
#Note: supervisor automatically started a new registry, with a new PID

"""
end
