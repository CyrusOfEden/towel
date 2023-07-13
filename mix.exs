defmodule Towel.MixProject do
  use Mix.Project

  def project do
    [app: :towel,
     description: "A delightfully simple monad library that's written for Elixir.",
     version: "0.2.2",
     elixir: "~> 1.0",
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: []]
  end

  def package do
    [licenses: ["MIT"],
     contributors: ["Cyrus Nouroozi"],
     links: %{"Github" => "https://github.com/CyrusOfEden/towel"}]
  end

  def application do
    []
  end
end
