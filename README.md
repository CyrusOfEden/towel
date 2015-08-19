# Towel [![Build Status](https://travis-ci.org/knrz/towel.svg)](https://travis-ci.org/knrz/towel)

**HERE BE DRAGONS. You should figure out how this lib works on your own for the time being—I look to have complete docs by September (2015), but until then, you're on your own.**

Simple, unobtrusive monads that anyone can use in Elixir.

## Installation

Keep calm and add Towel to your `mix.exs` dependencies:

```elixir
def deps do
  [{:towel, git: "https://github.com/knrz/towel.git", "~> 1.0.0"}]
end
```

and run `$ mix deps.get`.

You're ready to start righting more expressive code!

## Philosophy

Let's keep it Elixir. Forget Haskell's `Just` and `Nothing`; Elixir's already got its tuple-based `{:ok, value}` and `{:error, reason}` construct, so let's use that. That's why Towel's `Maybe` monad returns `{:ok, value}` and `{:error, reason}` instead of `:some` or `:none` or whatnot.

Elixir's got piping (`|>`). Piping is great, but not when you've got wrapped values. What if you've got a list in a `maybe`? Just keep your Towel handy:

```elixir
[1, 2, 3] |> bind(fn x -> x * x end)
# returns [1, 4, 9]
#
# Piping to bind(fn) passes each value of the monad
# (in this case the List monad) to fn and normalizes the result.
# Typically, you'd have to wrap your function's return value as a monad, like so:
#     [1, 2, 3] |> bind(fn x -> [x * x] end)
# but Towel automatically calls the appropriate monadic return function to wrap
# the return value of your function (in this case, List.wrap).
```

You only have to explicitly return `{:error, reason}` for the Maybe monad or an empty list (`[]`) for the List monad if you want to return the monad's 'invalid' state, so to speak.

```elixir
maybe(42) |> bind(fn a -> [answer: a] end)
# returns {:ok, [answer: 42]}
#
# But if you want to error out:
maybe(39)
|> bind fn a ->
  if a == 42, do: [answer: a], else: {:error, "there's no point"}
end
# returns {:error, "there's no point"}
```

## Usage

You'll have to add `use Towel` to the top of whatever module you're working in first (or just run it in `iex` to try it out):

```elixir
defmodule Hitchhiking.Galaxy do
  # Don't panic
  use Towel
end
```

## License

Copyright (c) 2015 Kash Nouroozi

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the LICENSE file for more details.