defmodule Ryal.PaymentMethodQuery do
  @moduledoc "Queries for the `Ryal.PaymentMethod`."

  use Ryal.Web, :query

  @doc "Get all payment gateways for a user from a payment method."
  @spec users_payment_gateways(Ecto.Schema.t()) :: Ecto.Query.t()
  def users_payment_gateways(payment_method) do
    Ecto.assoc(payment_method, [:user, :payment_gateways])
  end
end
