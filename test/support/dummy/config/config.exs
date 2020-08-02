use Mix.Config

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :logger,
  level: :warn,
  truncate: 4096

config :phoenix, :format_encoders, "json-api": Jason
config :phoenix, :json_library, Jason

config :dummy, Dummy.Endpoint,
  http: [port: 4001],
  server: false,
  url: [host: "localhost"],
  secret_key_base: "testing123",
  render_errors: [view: Dummy.ErrorView, accepts: ~w(html json json-api)]

config :ryal_core,
  repo: Dummy.Repo,
  user_module: Dummy.User,
  user_table: :users,
  payment_gateways: [
    %{type: :bogus},
    %{type: :stripe, token: "sk_test_123"}
  ]

import_config "./config.secret.exs"
