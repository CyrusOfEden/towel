defmodule Maybe do
  def wrap(m = {:just, _}), do: m
  def wrap(m = :nothing), do: m

  def wrap(nil), do: nothing()
  def wrap(v), do: just(v)

  def unwrap({:just, v}), do: unwrap(v)
  def unwrap(:nothing), do: nothing()
  def unwrap(v), do: v

  def just(v), do: {:just, unwrap(v)}
  def nothing, do: :nothing

  def is_just({:just, _}), do: true
  def is_just(_), do: false

  def is_nothing(:nothing), do: true
  def is_nothing(_), do: false
end

