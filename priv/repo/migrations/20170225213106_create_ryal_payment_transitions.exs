defmodule Ryal.Repo.Migrations.CreateRyalPaymentTransitions do
  use Ecto.Migration

  def change do
    create table(:ryal_payment_transitions) do
      add :from, :text, null: false
      add :to, :text, null: false
      add :event, :text, null: false
      add :result, :text, null: false

      add :payment_id, references(:ryal_payments), null: false

      timestamps()
    end
  end
end
