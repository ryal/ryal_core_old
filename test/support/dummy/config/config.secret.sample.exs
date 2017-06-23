use Mix.Config

config :dummy, Dummy.Repo,
  priv: "../ryal_core/priv/repo",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "ryal_dummy_#{Mix.env}",
  username: System.get_env("DUMMY_DB_USER") || System.get_env("USER")
