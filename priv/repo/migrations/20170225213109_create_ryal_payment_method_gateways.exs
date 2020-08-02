defmodule Ryal.Repo.Migrations.CreateRyalPaymentMethodGateways do
  use Ecto.Migration

  def change do
    create table(:ryal_payment_method_gateways) do
      add :external_id, :text, null: false

      add :payment_gateway_id, references(:ryal_payment_gateways), null: false
      add :payment_method_id, references(:ryal_payment_methods), null: false

      timestamps()
    end
  end
end
