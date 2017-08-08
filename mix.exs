defmodule Ryal.Core.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ryal_core,
      description: "The core of Ryal.",
      version: "0.0.1",
      build_path: "_build",
      config_path: "config/config.exs",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package: package(),
      deps: deps(),
      aliases: aliases(),
      compilers: [:phoenix] ++ Mix.compilers,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp aliases do
    [
      "db.reset": [
        "ecto.drop -r Dummy.Repo",
        "ecto.create -r Dummy.Repo",
        "dummy.migrate",
        "ecto.migrate -r Dummy.Repo"
      ]
    ]
  end

  def application do
    [
      mod: {Ryal.Core, []},
      applications: applications() ++ applications(Mix.env)
    ]
  end

  defp applications do
    [
      :phoenix, :phoenix_ecto, :logger, :ecto, :postgrex, :scrivener,
      :scrivener_ecto, :httpotion
    ]
  end

  defp applications(:test), do: [:bypass]
  defp applications(_), do: []

  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:ja_serializer, "~> 0.12"},
      {:phoenix, "~> 1.2"},
      {:phoenix_ecto, "~> 3.2.1"},
      {:postgrex, ">= 0.13.0"},
      {:scrivener_ecto, "~> 1.1"},
      {:httpotion, "~> 3.0.2"},

      {:ex_doc, "~> 0.14", only: :dev},

      {:bypass, "~> 0.6", only: :test},
      {:excoveralls, "~> 0.6", only: :test},

      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
    ]
  end

  defp elixirc_paths(env) when env in ~w(dev test)a, do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Ben A. Morgan"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/ryal/ryal"},
      files: ~w(config/config.exs lib priv web mix.exs LICENSE.txt README.md)
    ]
  end
end
