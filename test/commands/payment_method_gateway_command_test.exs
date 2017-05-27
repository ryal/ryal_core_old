defmodule Ryal.PaymentMethodGatewayCommandTest do
  use Ryal.ModelCase

  alias Dummy.{Repo, User}
  alias Ryal.{
    PaymentMethod, PaymentMethodGateway, PaymentMethodGatewayCommand,
    UserCommand
  }

  describe ".create/1" do
    setup do
      {:ok, user} = %User{email: "hello@example.com"}
        |> User.changeset
        |> UserCommand.create

      payment_method = %PaymentMethod{}
        |> PaymentMethod.changeset(%{
          type: "credit_card",
          user_id: user.id,
          proxy: %{
            name: "Bobby Orr",
            number: "4242 4242 4242 4242",
            month: "03",
            year: "2048",
            cvc: "004"
          }
        })
        |> Repo.insert!

      [
        payment_method: payment_method,
        user: user
      ]
    end

    test "will create the payment method gateway",
        %{payment_method: payment_method, user: user} do
      payment_gateway = user
        |> Ecto.assoc(:payment_gateways)
        |> Repo.all
        |> Enum.find(&(&1.type == "bogus"))

      %PaymentMethodGateway{}
      |> PaymentMethodGateway.changeset(%{
        payment_method_id: payment_method.id,
        payment_gateway_id: payment_gateway.id
      })
      |> PaymentMethodGatewayCommand.create

      assert Repo.one! PaymentMethodGateway
    end
  end
end
