defmodule Ryal.Core do
  @moduledoc """
  The core Ryal namespace. This guy is primarily used for configuration.
  """

  use Application

  import Application, only: [get_env: 2]

  alias Ryal.{PaymentGateway, PaymentMethod}

  @repo get_env(:ryal_core, :repo)
  @user_module get_env(:ryal_core, :user_module)
  @user_table get_env(:ryal_core, :user_table)

  @payment_gateway_modules get_env(:ryal_core, :payment_gateway_modules)
  @default_payment_gateway_modules %{
    bogus: PaymentGateway.Bogus,
    stripe: PaymentGateway.Stripe
  }

  @payment_methods get_env(:ryal_core, :payment_methods)
  @default_payment_methods %{
    credit_card: PaymentMethod.CreditCard
  }

  @spec payment_gateways() :: list
  def payment_gateways, do: get_env(:ryal_core, :payment_gateways) || []

  @spec default_payment_gateway() :: tuple | nil
  def default_payment_gateway, do: List.first(payment_gateways())

  @spec payment_gateway(atom) :: String.t | map
  def payment_gateway(type) do
    Enum.find(payment_gateways(), &(&1[:type] == type))
  end

  @spec payment_gateway_modules() :: %{}
  def payment_gateway_modules do
    Map.merge(@default_payment_gateway_modules, @payment_gateway_modules || %{})
  end

  @spec payment_gateway_module(atom) :: module | nil
  def payment_gateway_module(type), do: Map.get(payment_gateway_modules(), type)

  @spec fallback_gateways() :: list
  def fallback_gateways do
    [_default|fallbacks] = payment_gateways()
    fallbacks
  end

  @spec payment_methods() :: map
  def payment_methods do
    Map.merge(@default_payment_methods, @payment_methods || %{})
  end

  @spec payment_method(atom) :: module
  def payment_method(type), do: Map.get(payment_methods(), type)

  @spec default_payment_methods() :: map
  def default_payment_methods, do: @default_payment_methods

  @spec repo() :: module
  def repo, do: @repo

  @spec user_module() :: module
  def user_module, do: @user_module

  @spec user_table() :: module
  def user_table, do: @user_table

  @spec start(atom, list) :: Supervisor.on_start
  def start(:normal, []) do
    Supervisor.start_link([], [strategy: :one_for_one, name: Ryal.Supervisor])
  end
end
