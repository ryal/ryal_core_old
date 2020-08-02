defmodule Ryal.Repo.Migrations.CreateRyalPayments do
  use Ecto.Migration

  def change do
    create table(:ryal_payments) do
      add :number, :text, null: false
      add :state, :text, default: "pending", null: false
      add :amount, :decimal, null: false

      add :order_id, references(:ryal_orders), null: false

      timestamps()
    end

    create unique_index :ryal_payments, :number
  end
end
