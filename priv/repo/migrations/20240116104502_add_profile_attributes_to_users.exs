defmodule InvoiceGenerator.Repo.Migrations.AddProfileAttributesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
      add :avatar, :string
      add :address, :map
    end
  end
end
