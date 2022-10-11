defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    # start_supervised! function was injected into our test module by use ExUnit.Case
    # start_supervised! helps guarantee that the state of one test is not going to interfere with the next one in case they depend
    # on shared resources.
    #registry requires the :name when starting up
    _ = start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
    #registry = start_supervised!(KV.Registry)
    #%{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)

    #Do a call to ensure the registry processed the DOWN message. "bogus" bucket
    _ = KV.Registry.create(registry, "bogus")
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    #Stop the bucket with non-normal reason for crash all linked process
    #how to solve? -> defining a new supervisor(dynamic supervisor) that will spawn and supervise all buckets
    #here every child is tarted manually via dynamicSupervisor
    Agent.stop(bucket, :shutdown)

    #Do a call to ensure the registry processed the DOWN message. "bugus" bucket
    _ = KV.Registry.create(registry, "bogus")
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "bucket can crash at any time", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    #Simulate a bucket crash by explicitly and synchronously shutting it down
    Agent.stop(bucket, :shutdown)

    #Now trying to call the dead process causes a :noproc exit
    catch_exit KV.Bucket.put(bucket, "milk", 3)

  end


end
