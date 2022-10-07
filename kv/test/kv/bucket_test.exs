defmodule KV.BucketTest do
  # is responsible for setting up our module for testing and imports many test-related functionality
  # ex: test/2 macro
  use ExUnit.Case, async: true

  # async: true -> makes the test case run in parallel with other :async test cases by using multiple cores in our machine.
  # constrain: only be set if the test case does not rely on or change any global values
  # ex: writing to the filesystem or access a database (synchronous)

  # callbacks for skitp such repetitive tasks
  # setup/1 defines a callback that is run before every test, in the same process as the test itself
  setup do
    {:ok, bucket} = KV.Bucket.start_link([])
    %{bucket: bucket}
  end

  # pass the bucket pid from the callback to the test with 'test conext'
  # %{bucket: bucket} merge this map into the test conext
  # we can pattern match the bucket out of it with the test context becuase is a map
  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "delete key and get value if exists", %{bucket: bucket} do
    # assert KV.Bucket.get(bucket, "milk") == nil

    assert KV.Bucket.delete(bucket, "eggs") == nil
    KV.Bucket.put(bucket, "eggs", 2)
    assert KV.Bucket.delete(bucket, "eggs") == 2
  end

end
