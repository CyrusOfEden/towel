defprotocol Monad do
  def bind(m, f)
  def tap(m, f)
end

defimpl Monad, for: List do
  # List
  def bind(m, f) when is_function(f) do
    Enum.flat_map m, f
  end

  def tap(m, f) when is_function(f) do
    Enum.map m, fn i ->
      f.(i)
      i
    end
  end
end

defimpl Monad, for: Tuple do
  # Result
  def bind(m = {:error, _}, _), do: m
  def bind({:ok, v}, f) when is_function(f) do
    f.(v)
  end
  # Maybe
  def bind({:just, v}, f) when is_function(f) do
    f.(v)
  end

  # Result
  def tap(m = {:error, _}, _), do: m
  def tap({:ok, v}, f) when is_function(f) do
    f.(v)
    {:ok, v}
  end
  # Maybe
  def tap({:just, v}, f) when is_function(f) do
    f.(v)
    {:just, v}
  end
end

defimpl Monad, for: Atom do
  # Maybe
  def bind(:nothing, _), do: :nothing
  def tap(:nothing, _), do: :nothing
end
