defmodule Dummy.Mixfile do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :dummy,
      elixirc_paths: ["lib"],
      config_path: "config/config.exs",
      version: "1.0.0",
      build_embedded: false,
      start_permanent: false,
      compilers: [:phoenix] ++ Mix.compilers(),
      deps: [
        {:postgrex, ">= 0.0.0"},
        {:ecto, "~> 3.0"},
        {:ecto_sql, "~> 3.0"},
        {:phoenix, "~> 1.5"},
        {:phoenix_ecto, "~> 4.1"},
        {:ja_serializer, "~> 0.15"},
        {:scrivener_ecto, "~> 2.4"}
      ]
    ]
  end

  def application, do: [mod: {Dummy, []}]
end
