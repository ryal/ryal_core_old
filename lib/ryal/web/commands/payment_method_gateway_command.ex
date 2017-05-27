defmodule Ryal.PaymentMethodGatewayCommand do
  alias Ryal.Core

  def create(changeset) do
    with {:ok, payment_method_gateway} <- Core.repo.insert(changeset),
         payment_method <- get_payment_method(payment_method_gateway),
         payment_gateway <- get_payment_gateway(payment_method_gateway),
      do: create_on_payment_gateway(payment_method, payment_gateway)
  end

  defp get_payment_method(payment_method_gateway) do
    payment_method_gateway
    |> Ecto.assoc(:payment_method)
    |> Core.repo.one
  end

  defp get_payment_gateway(payment_method_gateway) do
    payment_method_gateway
    |> Ecto.assoc(:payment_gateway)
    |> Core.repo.one
  end

  defp create_on_payment_gateway(payment_method, payment_gateway) do
    payment_method_type = String.to_atom(payment_method.type)
    payment_gateway_type = String.to_atom(payment_gateway.type)

    with {:ok, payment_gateway_module} <-
           Core.payment_gateway_module(payment_gateway_type),
      do: payment_gateway_module.create(payment_method_type, payment_method)
  end
end
