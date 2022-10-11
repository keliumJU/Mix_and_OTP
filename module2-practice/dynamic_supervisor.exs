#inside iex -S mix
#Add child process to dynamic supervisor
{:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)

IO.inspect KV.Bucket.put(bucket, "eggs", 3)

IO.inspect KV.Bucket.get(bucket, "eggs")

#Now change the registry(KV.Registry) to use the dynamic supervisor

#Observer command, observer is a tool that ships with Erlang
#containing all sorts of information about our system, from general satistics to load
#charts as well as a list of all running processes and applications
:observer.start
