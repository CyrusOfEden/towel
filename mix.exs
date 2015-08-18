defmodule Towel.Mixfile do
  use Mix.Project

  def project do
    [app: :towel,
     description: "Simple monads for Elixir, in Elixir-style (not Haskell!)",
     version: "0.0.1",
     elixir: "~> 1.0",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def package do
    [licenses: ["MIT"],
     contributors: ["Kash Nouroozi"],
     links: %{ "Github" => "https://github.com/knrz/towel" }]
  end

  def application do
    []
  end

  defp deps do
    []
  end
end
