defmodule Ryal.Repo.Migrations.CreateRyalOrders do
  use Ecto.Migration

  def change do
    create table(:ryal_orders) do
      add :number, :text, null: false
      add :state, :text, default: "cart", null: false
      add :total, :decimal, null: false

      add :user_id, references(Ryal.Core.user_table()), null: false

      timestamps()
    end

    create unique_index :ryal_orders, :number
  end
end
