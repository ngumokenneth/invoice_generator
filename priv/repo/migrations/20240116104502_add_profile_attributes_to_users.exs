defmodule InvoiceGenerator.Repo.Migrations.AddProfileAttributesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
      add :avatar, :string

      add :country, :string
      add :city, :string
      add :postal_code, :string
      add :street_address, :string
      add :phone_number, :string
    end
  end
end
