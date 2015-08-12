defprotocol Functor do
  def fmap(m, f)
end

defimpl Functor, for: List do
  # List
  def fmap(m, f) when is_function(f) do
    Enum.map m, f
  end
end

defimpl Functor, for: Function do
  # Function
  def fmap(lhs, rhs) do
    fn x ->
      lhs.(rhs.(x))
    end
  end
end

defimpl Functor, for: Tuple do
  # Maybe
  def fmap(m = {:error, _}, _), do: m
  def fmap({:ok, v}, f) when is_function(f) do
    Maybe.wrap f.(v)
  end
end
