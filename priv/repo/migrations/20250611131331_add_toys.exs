defmodule ErrorDemo.Repo.Migrations.AddToys do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:toys, primary_key: false) do
      add(:id, :uuid, null: false, default: fragment("uuid_generate_v7()"), primary_key: true)

      add(
        :child_id,
        references(:children,
          column: :id,
          name: "toys_child_id_fkey",
          type: :uuid,
          prefix: "public"
        )
      )
    end
  end

  def down do
    drop(constraint(:toys, "toys_child_id_fkey"))

    drop(table(:toys))
  end
end
