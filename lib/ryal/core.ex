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

  @default_payment_gateway get_env(:ryal_core, :default_payment_gateway)

  @payment_gateway_modules get_env(:ryal_core, :payment_gateway_modules)
  @default_payment_gateway_modules %{
    bogus: PaymentGateway.Bogus,
    stripe: PaymentGateway.Stripe
  }

  @payment_methods get_env(:ryal_core, :payment_methods)
  @default_payment_methods %{
    credit_card: PaymentMethod.CreditCard
  }

  def payment_gateways, do: get_env(:ryal_core, :payment_gateways) || %{}
  def default_payment_gateway, do: @default_payment_gateway

  def payment_gateway_modules do
    Map.merge(@default_payment_gateway_modules, @payment_gateway_modules || %{})
  end

  def payment_gateway_module(type), do: Map.get(payment_gateway_modules(), type)

  def fallback_gateways do
    Map.keys(payment_gateways()) -- [@default_payment_gateway]
  end

  def payment_methods do
    Map.merge(@default_payment_methods, @payment_methods || %{})
  end

  def payment_method(type), do: Map.get(payment_methods(), type)
  def default_payment_methods, do: @default_payment_methods

  def repo, do: @repo
  def user_module, do: @user_module
  def user_table, do: @user_table

  @spec start(atom, list) :: Supervisor.on_start
  def start(:normal, []) do
    Supervisor.start_link([], [strategy: :one_for_one, name: Ryal.Supervisor])
  end
end
