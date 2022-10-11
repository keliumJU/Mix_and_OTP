defmodule KV do

  #To implement the Application behaviour, we have to use Application and define a start/2 function
  use Application

  @impl true
  def start(_type, _args) do
    #Although we don't use the supervisor name below directly,
    #it can be useful when debuggin or introspecting the system.
    KV.Supervisor.start_link(name: KV.Supervisor)
  end

end
