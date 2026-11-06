defmodule Pollutiondb.Repo.Migrations.AddUniqueIndexes do
  use Ecto.Migration

  def change do
    alter table(:stations) do
      add :external_id, :string
    end

    create unique_index(:stations, [:external_id])

    create unique_index(:readings, [:station_id, :date, :time, :type])
  end
end
