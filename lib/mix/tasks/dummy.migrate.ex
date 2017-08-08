defmodule Mix.Tasks.Dummy.Migrate do
  @moduledoc "Runs all Dummy migrations."

  alias Ecto.Migrator
  alias Dummy.Repo

  use Mix.Task

  @doc "Get the dummy path and run the migrations for that folder."
  def run(_args) do
    {:ok, _apps} = Application.ensure_all_started(:ryal_core, :temporary)
    {:ok, _pid} = Repo.start_link()

    relative_path = "test/support/dummy/priv/repo/migrations"
    path = Application.app_dir(:ryal_core, relative_path)
    Migrator.run(Repo, path, :up, all: true)
  end
end
