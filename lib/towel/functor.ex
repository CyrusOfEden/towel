defprotocol Towel.Functor do
  def fmap(m, f)
  def combine(ms, acc)
end

defimpl Towel.Functor, for: List do
  # List
  def fmap(m, f) when is_function(f) do
    Enum.map m, f
  end

  def combine(m, m), do: m ++ m
end

defimpl Towel.Functor, for: Function do
  # Function
  def fmap(lhs, rhs) do
    fn x ->
      lhs.(rhs.(x))
    end
  end

  def combine(lhs, rhs), do: fmap(lhs, rhs)
end

defimpl Towel.Functor, for: Tuple do
  # Result
  def fmap(m = {:error, _}, _), do: m
  def fmap({:ok, v}, f) when is_function(f) do
    Towel.Result.wrap f.(v)
  end
  # Maybe
  def fmap({:just, v}, f) when is_function(f) do
    Towel.Maybe.wrap f.(v)
  end

  # Result
  def combine({:error, r}, _), do: {:error, r}
  def combine(_, {:error, r}), do: {:error, r}
  def combine({:ok, va}, {:ok, vb}) do
    {:ok, {va,vb}}
  end
  # Maybe
  def combine({:just, va}, {:just, vb}) do
    {:just, {va,vb}}
  end
end

defimpl Towel.Functor, for: Atom do
  # Maybe
  def fmap(:nothing, _), do: :nothing
  # Maybe
  def combine(:nothing, _), do: :nothing
  def combine(_, :nothing), do: :nothing
end
