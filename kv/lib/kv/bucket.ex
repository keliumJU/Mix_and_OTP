defmodule KV.Bucket do
  #We want to say that bucket are actually temporary
  #if they crash, regardless of the reason, they should not be restarted
  use Agent, restart: :temporary

  @doc """
    start a new bucket
  """
  def start_link(list) do
    Agent.start_link(fn -> list end)
  end

  @doc """
    Gets a value from the `bucket` by `key`
  """
  def get(agent, string) do
    list = Agent.get(agent, fn content -> content end)

    ans =
      list
      |> Enum.filter(fn x -> elem(x, 0) == string end)

    if(ans != []) do
      Enum.at(ans, 0) |> elem(1)
    else
      nil
    end
  end

  @doc """
    Puts the `value` for given `key` in the `bucket`
  """
  def put(agent, string, num) do
    Agent.update(agent, fn list -> [{string, num} | list] end)
  end

  @doc """
    Deletes `key` from `bucket`
    Returns the current value of `key`, if `key` exists.
  """
  def delete(agent, key) do
    # that is the client out
    Agent.get_and_update(agent, fn content ->
      # that is the server into
      list_with_key = content |> Enum.filter(fn x -> elem(x, 0) == key end)

      if list_with_key != [] do
        ele_list = Enum.at(list_with_key, 0)
        value = elem(ele_list, 1)
        new_content = List.delete(content, ele_list)
        {value, new_content}
      else
        {nil, content}
      end
    end)
  end
end
