defmodule Ryal.PaymentGatewayCommand do
  @moduledoc """
  CRUD commands for `Ryal.PaymentGateway`s. Often used to managed the
  `external_id`s from payment gateways.
  """

  alias Ryal.{Core, PaymentGateway}

  @doc "Shorthand for creating all the payment gateways relevant to a user."
  @spec create(Ecto.Schema.t) ::
     {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def create(user) do
    [{default_gateway_type, _data}|fallback_gateways] = Core.payment_gateways()

    Enum.each fallback_gateways, fn({gateway_type, _gateway_data}) ->
      spawn_monitor fn -> create(gateway_type, user) end
    end

    create default_gateway_type, user
  end

  @doc """
  Given a user and a gateway type, we'll create a new `Ryal.PaymentGateway` for
  that user.
  """
  @spec create(atom, Ecto.Schema.t) ::
    {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def create(type, user, endpoint \\ nil) do
    struct = %PaymentGateway{type: Atom.to_string(type), user_id: user.id}

    with {:ok, external_id} <-
           payment_gateway(type).create(:customer, %{user: user}, endpoint),
         changeset <-
           PaymentGateway.changeset(%{struct | external_id: external_id}),
      do: Core.repo.insert(changeset)
  end

  @doc """
  Give us a user and we'll update the payment gateways with the user's
  information.
  """
  @spec update(Ecto.Schema.t) :: []
  def update(user) do
    user = Core.repo.preload(user, :payment_gateways)

    Enum.map user.payment_gateways, fn(payment_gateway) ->
      type = String.to_atom payment_gateway.type
      spawn_monitor payment_gateway(type), :update, [:customer, %{
        external_id: payment_gateway.external_id, user: user
      }]
    end
  end

  @doc """
  If you're going to be deleting your user, then we'll delete the user on the
  payment gateway as well.
  """
  @spec delete(Ecto.Schema.t) :: []
  def delete(user) do
    user = Core.repo.preload(user, :payment_gateways)

    Enum.map user.payment_gateways, fn(payment_gateway) ->
      type = String.to_atom payment_gateway.type
      spawn_monitor payment_gateway(type), :delete, [:customer, %{
        external_id: payment_gateway.external_id
      }]
    end
  end

  defp payment_gateway(type), do: Core.payment_gateway_module(type)
end
