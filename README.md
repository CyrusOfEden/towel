# Towel [![Build Status](https://travis-ci.org/knrz/towel.svg)](https://travis-ci.org/knrz/towel)

A delightfully simple monad library that's written for Elixir.

## Installation

Keep calm and add Towel to your `mix.exs` dependencies:

```elixir
def deps do
  [{:towel, "~> 0.2.1"}]
end
```

and run `$ mix deps.get`.

You're ready to start righting more expressive code!

## Philosophy

Let's keep it Elixir. Forget Haskell's `Just` and `Nothing`; Elixir's already got its tuple-based `{:ok, value}` and `{:error, reason}` construct, so let's use that. That's why Towel's `Result` monad returns `{:ok, value}` and `{:error, reason}` instead of `:some` or `:none` or whatnot.

Elixir's got piping (`|>`). Piping is great, but not when you've got wrapped values. Keep your towel on you:

```elixir
ok([answer: 42])
|> fmap(&Map.get(&1, :answer))
# {:ok, 42}
```

## Quick Start

What if you're going to run into an error along the way? Say you want to travel through a map, but aren't sure whether or not a key is going to have a value.

```elixir
map = %{system: "sol", z: %{z: %{nine: %{plural: %{z: %{alpha: "earth"}}}}}}
path = [:z, :z, :nine, :plural, :z, :alpha]

planet = List.foldl path, wrap(map), fn key, m ->
  fmap(m, &Map.get(&1, key))
end
# {:ok, "earth"}
```

 Woah! Did that just work?? Yes it did. But what if our path list was messed up and we didn't have a proper path? What if it was like this?

```elixir
map = %{system: "sol", z: %{z: %{nine: %{plural: %{z: %{alpha: "earth"}}}}}}
path = [:z, :z, :ten, :plural, :z, :alpha]

planet = List.foldl path, wrap(map), fn key, m ->
  fmap(m, &Map.get(&1, key))
end
# {:error, nil}
```

Look at that! You didn't even need a dolphin and your code safely ran without raising an error. Let's take a look at our functions list.

## Tour of the ~~Galaxy~~ Library

Note: When you `use Towel`, all the following functions (except `wrap` and `unwrap`) are added to the global namespace.

### Result

**wrap/1** The Elixir version of Haskell's Monad.return. Whatever you pass into it, whether it be a pre-existing monad or a regular, unwrapped value, it will return a value wrapped in an `ok`. If `nil` or `:error` is passed into it, it will return an `error`.

```elixir
wrap(nil)    # {:error, nil}
wrap(:error) # {:error, nil}
wrap(true)   # {:ok, true}
wrap(false)  # {:ok, false}
wrap("mice") # {:ok, mice}
```

**unwrap/1** does the opposite—it'll give you your bare value, no matter how many times it may have been wrapped by a result.

```elixir
unwrap({:ok, {:ok, {:ok, 42}}}) # 42
unwrap(nil)                     # nil
unwrap({:error, "no point"})    # "no point"
```

**ok/1** wraps whatever you pass into it in an `ok`. For when you want to explicitly state that the wrapped value is, in fact, OK.

**error/0, error/1** wraps whatever you pass into it in an `error`. For when you want to explicitly state that there's a problem with the error.

### Maybe

**wrap/1** will do the minimum work required to wrap a value in either `just` or return `:nothing`. Note that only `nil` will return `nothing`.

**unwrap/1** does the opposite—it will do all the work required to take a value out of a monad.

**just/1** will wrap the provided value in a `just`.

**nothing/0** will return the atom `:nothing`.

### Monad

**bind/2** takes a monad and a function, and applies the function with the wrapped value of the monad if the monad is `ok`. Silently passes if the monad is an `error`. Expects the return _value_ of the function to be either `{:ok, value}` or `{:error, reason}`. You can use `Result.ok` and `Result.error` instead.

```elixir
File.read("inspirational_quotes.txt")
|> bind(fn quotes ->
  if length(quotes) > 0 do
    ok(quotes)
  else
    error("life's depressing.")
  end
end)
```

**tap/2** takes a monad and a function, applies the function to the value, and returns the monad. This is useful for adding side-effects (_gasp_ impurity!).

```elixir
File.read("inspirational_quotes.txt")
|> tap(&IO.puts/1)
```

### Functor

**fmap/2** takes a monad and a function, and applies the function with the wrapped value of the monad if the monad is `ok`. Silently passes if the monad is an `error`. Will automatically wrap the return value by passing it to the appropriate `Monad.wrap` function.

```elixir
File.read("inspirational_quotes.txt")
|> fmap(fn quotes ->
  if length(quotes) > 0, do: quotes, else: nil
end)
```

**combine/2** takes 2 monads of the same type and reduces them into either `{:error, reason}` if there was an `error` in the list, or `{:ok, values}`, where `values` is a list of all the wrapped values, in the order they were passed in.

```elixir
case combine(network_request(params), db_request(query)) do
  {:ok, [response, record]} ->
    # do stuff
  {:error, reason} ->
    Logger.debug("There was a problem. What kind of problem? I don't know.")
end
```

## Usage

Just add `use Towel` to the top of whatever module you're working in first (or just run it in `iex` to try it out):

```elixir
defmodule Hitchhiking.Galaxy do
  # Don't panic
  use Towel
end
```

## Is it any good?

Yes.

## License

Copyright (c) 2015 Kash Nouroozi

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the LICENSE file for more details.