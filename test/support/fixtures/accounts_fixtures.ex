defmodule InvoiceGenerator.AccountsFixtures do
  alias InvoiceGenerator.Accounts

  @moduledoc """
  This module defines test helpers for creating
  entities via the `InvoiceGenerator.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> InvoiceGenerator.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  def confirm_email(user) do
    {:ok, user} =
      extract_user_token(fn url -> Accounts.deliver_user_confirmation_instructions(user, url) end)
      |> Accounts.confirm_user()

    user
  end
end
