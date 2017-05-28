defmodule Ryal.PaymentMethodCommand do
  @moduledoc """
  The home of the create and delete functions for a user's payment method. Use
  these to easily manage the numerous ways of managing - say - a credit card
  with stripe.
  """

  alias Ryal.{
    Core, PaymentMethodGateway, PaymentMethodGatewayCommand, PaymentMethodQuery
  }

  @doc """
  This funtion requires the changeset and the data the user submitted of their
  payment method. We actually delete the sensitive data in the changeset to
  it's not persisted in the DB. That's why we require the second param here,
  which should hold that sensitive data that will be used ephemerally.

  When we create the payment method, we'll also head back to the user, grab all
  of their payment gateways, and then create the credit card on each payment
  gateway. They all run async, except or their default one, which is mainly so
  that you can always trust their's at least one active payment method for a
  user and fallbacks available.
  """
  @spec create(Ecto.Changeset.t, map) :: {:ok, Ecto.Schema.t}
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
    |> PaymentMethodQuery.users_payment_gateways
    |> Core.repo.all
  end

  # TODO: "What if the third party fails, retry later?"
  defp create_with_default_payment_gateway(payment_method, payment_gateways, payment_method_data) do
    payment_gateways
    |> Enum.find(&default_payment_gateway?/1)
    |> create_payment_method_gateway(payment_method, payment_method_data)
  end

  # TODO: "What if the third party fails, retry later?"
  defp create_with_fallback_payment_gateways(payment_method, payment_gateways, payment_method_data) do
    payment_gateways
    |> Enum.reject(&default_payment_gateway?/1)
    |> Enum.each(fn(payment_gateway) ->
      spawn_monitor fn ->
        create_payment_method_gateway(payment_gateway, payment_method, payment_method_data)
      end
    end)
  end

  defp create_payment_method_gateway(payment_gateway, _payment_method, _payment_method_data)
      when is_nil(payment_gateway), do: nil

  defp create_payment_method_gateway(payment_gateway, payment_method, payment_method_data) do
    %PaymentMethodGateway{}
    |> PaymentMethodGateway.changeset(%{
      payment_method_id: payment_method.id,
      payment_gateway_id: payment_gateway.id
    })
    |> PaymentMethodGatewayCommand.create(payment_method_data)
  end

  defp default_payment_gateway?(payment_gateway) do
    String.to_atom(payment_gateway.type) == Core.default_payment_gateway()
  end

  @doc """
  The infamous delete function which will not only delete the payment method,
  but also its profiles as well on third parties.
  """
  def delete(changeset) do
    Core.repo.delete(changeset)
  end
end
