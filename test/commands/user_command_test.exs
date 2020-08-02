defmodule Ryal.UserCommandTest do
  use Ryal.ModelCase

  alias Dummy.User

  alias Ryal.Core
  alias Ryal.PaymentGateway
  alias Ryal.UserCommand

  describe ".create/1" do
    test "will create a user with payment gateway" do
      changeset = Core.user_module().changeset(%User{email: "test@ryal.com"})

      assert [] == Repo.all(User)
      assert [] == Repo.all(PaymentGateway)

      assert {:ok, _user} = UserCommand.create(changeset)

      assert Repo.one!(User)
      assert Repo.one!(PaymentGateway)
    end
  end

  describe ".update/1" do
    setup do
      {:ok, user} =
        %User{}
        |> User.changeset(%{email: "ryal@example.com"})
        |> UserCommand.create()

      [user: user]
    end

    test "will update a user", %{user: user} do
      {:ok, user} =
        user
        |> User.changeset(%{email: "ryal@updated.com"})
        |> UserCommand.update()

      assert user.email == "ryal@updated.com"
    end

    test "will update payment gateway data", %{user: user} do
      process_list_before = Process.list()

      {:ok, _user} =
        user
        |> User.changeset(%{email: "ryal@updated.com"})
        |> UserCommand.update()

      pids = Process.list() -- process_list_before
      assert Enum.count(pids) >= 1
    end
  end

  describe ".delete/1" do
    setup do
      {:ok, user} =
        %User{}
        |> User.changeset(%{email: "ryal@example.com"})
        |> UserCommand.create()

      [user: user]
    end

    test "will delete the user from a payment gateway", %{user: user} do
      {:ok, _} = UserCommand.delete(user)

      assert_raise Ecto.NoResultsError, fn ->
        Repo.get!(Core.user_module(), user.id)
      end
    end
  end
end
