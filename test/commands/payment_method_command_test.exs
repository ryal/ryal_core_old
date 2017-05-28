defmodule Ryal.PaymentMethodCommandTest do
  use Ryal.ModelCase

  alias Dummy.{Repo, User}
  alias Ryal.{
    PaymentMethod, PaymentMethodGateway, PaymentGatewayCommand,
    PaymentMethodCommand
  }

  setup do
    user = %User{email: "hello@example.com"}
      |> User.changeset
      |> Repo.insert!

    [user: user]
  end

  describe ".create/1" do
    setup %{user: user} do
      credit_card_data = %{
        name: "Bobby Orr",
        number: "4242 4242 4242 4242",
        month: "03",
        year: "2048",
        cvc: "004"
      }

      changeset = PaymentMethod.changeset(%PaymentMethod{}, %{
        type: "credit_card",
        user_id: user.id,
        proxy: credit_card_data
      })

      [
        changeset: changeset,
        credit_card_data: credit_card_data
      ]
    end

    test "will insert the payment method", %{
        changeset: changeset, credit_card_data: credit_card_data} do
      PaymentMethodCommand.create(changeset, credit_card_data)

      assert Repo.one!(PaymentMethod)
    end

    test "will create a payment method gateway", %{
        user: user, changeset: changeset, credit_card_data: credit_card_data} do
      PaymentGatewayCommand.create(user)
      PaymentMethodCommand.create(changeset, credit_card_data)

      assert Repo.one!(PaymentMethodGateway)
    end
  end
end
