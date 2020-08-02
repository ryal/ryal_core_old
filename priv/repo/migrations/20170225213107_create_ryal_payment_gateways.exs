defmodule Ryal.Repo.Migrations.CreateRyalUserGateways do
  use Ecto.Migration

  def change do
    create table(:ryal_payment_gateways) do
      add :type, :text, null: false
      add :external_id, :text, null: false

      add :user_id, references(Ryal.Core.user_table(), on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
