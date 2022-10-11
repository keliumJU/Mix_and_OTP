
#Starting applications
# does not work outside of iex -S mix
#how to start our application
#IO.inspect Application.start(:kv)

#Each application in our system can be started and stopped.
#stop application -> iex -S mix run --no-start
#stop application on iex -> Application.stop(:kv)
#stop application on iex -> Application.stop(:logger)

#Note: We need to either start each application manually in the correct order or
#call Application.ensure_all_started
#IO.inspect Application.ensure_all_started(:kv)

#We can customize what happens when our application start with callbacks in mix.exsfile

#Note important: When we say "project" you should think about Mix -> the tool that manages your project(compile,test,start...)
#-When we talk about applications, we talk about OTP(Open telecom plataform) -> applications are the entities that are started
#and stopped as a whole by the runtime
