defmodule Ryal.PaymentMethodGatewayCommand do
  @moduledoc """
  Here exists the CD of a payment method tied to a payment gateway. This does
  heavy lifting for creating a payment method on a payment gateway.
  """

  alias Ryal.{Core, PaymentGateway, PaymentMethod, PaymentMethodGateway}

  @doc """
  Creates a profile of the payment method and then creates a
  `Ryal.PaymentMethodGateway`.
  """
  def create(changeset, payment_method_data, endpoint \\ nil) do
    with  payment_method <-
            Core.repo.get(PaymentMethod, changeset.changes.payment_method_id),
          payment_gateway <-
            Core.repo.get(PaymentGateway, changeset.changes.payment_gateway_id),
          {:ok, external_id} <-
            create_on_payment_gateway(
              payment_method, payment_method_data, payment_gateway, endpoint
            ),
          changeset <- rebuild_changeset(changeset, external_id),
      do: Core.repo.insert(changeset)
  end

  defp create_on_payment_gateway(payment_method, payment_method_data, payment_gateway, endpoint) do
    payment_method_type = String.to_atom(payment_method.type)
    payment_gateway_type = String.to_atom(payment_gateway.type)
    payment_gateway_module = Core.payment_gateway_module(payment_gateway_type)

    data = %{customer_id: payment_gateway.external_id}
      |> Map.put(payment_method_type, payment_method_data)

    if endpoint do
      payment_gateway_module.create(payment_method_type, data, endpoint)
    else
      payment_gateway_module.create(payment_method_type, data)
    end
  end

  defp rebuild_changeset(changeset, external_id) do
    changeset
    |> Ecto.Changeset.apply_changes
    |> Map.merge(%{external_id: external_id})
    |> PaymentMethodGateway.changeset
  end
end
