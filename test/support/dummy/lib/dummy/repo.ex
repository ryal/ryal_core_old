defmodule Dummy.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :dummy, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 20
end
