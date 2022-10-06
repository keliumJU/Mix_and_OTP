#Agents 
#This is the practice of the exercises of the cmd: iex -S mix
IO.puts""
IO.puts"Agents"
#starting a bound process that allows me to store values
IO.inspect {:ok, agent} = Agent.start_link fn -> [] end
IO.inspect Agent.update(agent, fn list -> ["eggs" | list] end)
IO.inspect Agent.stop(agent)

IO.puts""
IO.puts"cumulative agent"
IO.inspect {:ok,agent} = Agent.start_link fn -> [] end
IO.inspect Agent.update(agent, fn _list -> 123 end)
IO.inspect Agent.update(agent, fn content -> %{a: content} end)
IO.inspect Agent.update(agent, fn content -> [12 | [content]] end)
IO.inspect Agent.update(agent, fn list -> [:nop | list] end)
IO.inspect Agent.get(agent, fn content -> content end)


{:ok, agent2} = Agent.start_link(fn -> [] end)
Agent.update(agent2, fn list -> [{"milk",3}|list] end)
Agent.update(agent2, fn list -> [{"eggs",1}|list] end)
IO.inspect Agent.get(agent2, fn content -> content end)

list = Agent.get(agent2, fn content -> content end) 
IO.puts"test get and update"
new_list = Agent.get_and_update(agent2, fn dict ->  
    {3, dict}
  end)
IO.inspect Agent.get(agent2, fn content -> content end)
IO.inspect(new_list)

