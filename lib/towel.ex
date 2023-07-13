defmodule Towel do
  @doc "Carry your towel with you."

  defmacro __using__(_opts) do
    quote do
      alias Towel.{Monad, Functor, Result, Maybe}
      import Monad
      import Functor
      import Result, except: [wrap: 1, unwrap: 1]
      import Maybe, except: [wrap: 1, unwrap: 1]
    end
  end
end
