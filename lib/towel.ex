defmodule Towel do
  defmacro __using__(_opts) do
    quote do
      import Monad
      import Functor
      import Result, except: [wrap: 1, unwrap: 1]
      import Maybe, except: [wrap: 1, unwrap: 1]
    end
  end
end
