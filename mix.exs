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
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      aliases: aliases(),
      compilers: [:phoenix] ++ Mix.compilers(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
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
    [extra_applications: [:logger], mod: {Ryal.Core, []}]
  end

  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:ja_serializer, "~> 0.15"},
      {:cowlib, "~> 2.8.0"},
      {:phoenix, "~> 1.5"},
      {:phoenix_ecto, "~> 4.1"},
      {:postgrex, ">= 0.15.0"},
      {:scrivener_ecto, "~> 2.4"},
      {:httpotion, "~> 3.1"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:bypass, "~> 1.0", only: :test},
      {:excoveralls, "~> 0.13", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dummy, path: "test/support/dummy", only: [:dev, :test], optional: true}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
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
