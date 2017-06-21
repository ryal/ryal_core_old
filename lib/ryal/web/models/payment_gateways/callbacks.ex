defmodule Ryal.PaymentGateway.Callbacks do
  @moduledoc """
  This is the behaviour for all of the payment gateways that we've setup. Please
  use this guy if you'd like to create your own. This way you don't make many
  mistkaes and you get warnings when you update Ryal.
  """

  @callback create(atom, %{}, String.t | nil) :: {:ok, %{}}
  @callback create(atom, %{}) :: {:ok, %{}}

  @callback update(atom, %{}, String.t | nil) :: {:ok, %{}}
  @callback update(atom, %{}) :: {:ok, %{}}

  @callback delete(atom, %{}, String.t | nil) :: {:ok, %{}}
  @callback delete(atom, %{}) :: {:ok, %{}}

  @optional_callbacks create: 2, update: 2, delete: 2
end
