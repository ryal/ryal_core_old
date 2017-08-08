defmodule Dummy.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :ryal_core
  use Scrivener, page_size: 20
end
