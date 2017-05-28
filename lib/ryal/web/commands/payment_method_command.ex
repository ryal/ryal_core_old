defmodule Ryal.PaymentMethodCommand do
  alias Ryal.{Core, PaymentMethodGateway, PaymentMethodGatewayCommand}

  def create(changeset, payment_method_data) do
    with {:ok, payment_method} <- Core.repo.insert(changeset),
         payment_gateways <- query_payment_gateways(payment_method),
         {:ok, _default_payment_gateway} <-
            create_with_default_payment_gateway(payment_method, payment_gateways, payment_method_data),
         {:ok, [_]} <-
            create_with_fallback_payment_gateways(payment_method, payment_gateways, payment_method_data),
      do: {:ok, payment_method}
  end

  defp query_payment_gateways(payment_method) do
    payment_method
    |> Ecto.assoc([:user, :payment_gateways])
    |> Core.repo.all
  end

  defp create_with_default_payment_gateway(payment_method, payment_gateways, payment_method_data) do
    payment_gateways
    |> Enum.find(&default_payment_gateway?/1)
    |> create_payment_method_gateway(payment_method, payment_method_data)
  end

  defp create_with_fallback_payment_gateways(payment_method, payment_gateways, payment_method_data) do
    payment_gateways
    |> Enum.reject(&default_payment_gateway?/1)
    |> Enum.each(fn(payment_gateway) ->
      spawn_monitor fn ->
        create_payment_method_gateway(payment_gateway, payment_method, payment_method_data)
      end
    end)
  end

  defp create_payment_method_gateway(payment_gateway, payment_method, payment_method_data) do
    if payment_gateway do
      %PaymentMethodGateway{}
      |> PaymentMethodGateway.changeset(%{
        payment_method_id: payment_method.id,
        payment_gateway_id: payment_gateway.id
      })
      |> PaymentMethodGatewayCommand.create(payment_method_data)
    end
  end

  defp default_payment_gateway?(payment_gateway) do
    String.to_atom(payment_gateway.type) == Core.default_payment_gateway()
  end

  def delete(changeset) do
    Core.repo.delete(changeset)
  end
end
