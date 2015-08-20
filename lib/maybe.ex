defmodule Maybe do
  def wrap(m = {:ok, _}), do: m
  def wrap(m = {:error, _}), do: m

  def wrap(nil), do: error
  def wrap(:error), do: error
  def wrap(v), do: ok(v)

  def unwrap({t, v}) when t in [:ok, :error], do: unwrap(v)
  def unwrap(x), do: x

  def ok(v), do: {:ok, v}

  def error, do: {:error, nil}
  def error(r), do: {:error, r}

  def combine(ms) when is_list(ms) do
    case List.keyfind(ms, :error, 0) do
      {:error, reason} ->
        error(reason)
      nil ->
        ok(Enum.map(ms, &elem(&1, 1)))
    end
  end
end