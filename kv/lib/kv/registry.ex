defmodule KV.Registry do
  use GenServer
  ##Client API

  ## Missing Client API - will add this later
  @doc """
  Starts the registry with the given options.

  `:name` is always required
  """
  def start_link(opts) do
    # 1. Pass the name to GenServer's init
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`
  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise
  """
  def lookup(server, name) do
    #2. Lookup is now done directly in ETS, without accessing the server
    case :ets.lookup(server, name) do
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end
    #GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  ## Defining GenServer Callbacks

  ## Server callbacks

  @impl true
  def init(table) do
    # 3. We have replaced the names map by the ETS table, "read_concurrency: true"
    names = :ets.new(table, [:named_table, read_concurrency: true])
    #names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  # 4. The previous handle_call callback for lookup was removed

  @impl true
  def handle_call({:create, name}, _from, {names, refs}) do
    # 5. Read and write to the ETS table instead of the map

    case lookup(names, name) do
      {:ok, pid} ->
        {:reply, pid, {names, refs}}
      :error ->
        #{:ok, bucket} = KV.Bucket.start_link([])
        #Now with dynamic supervisor
        {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        ref = Process.monitor(pid)
        refs = Map.put(refs, ref, name)
        #names = Map.put(names, name, pid)
        :ets.insert(names, {name, pid})
        {:reply, pid, {names, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    # 6. Delete from the ETS table instead of the map
    {name, refs} = Map.pop(refs, ref)
    #names = Map.delete(names, name)
    :ets.delete(names,name)
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info(_msg, state) do
    #require Logger
    #Logger.debug("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state}
  end

end
