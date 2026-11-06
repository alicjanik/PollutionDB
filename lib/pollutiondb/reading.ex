defmodule Pollutiondb.Reading do
  require Ecto.Query
  use Ecto.Schema

  schema "readings" do
    field :date, :date
    field :time, :time
    field :type, :string
    field :value, :float
    belongs_to :station, Pollutiondb.Station
  end


 def add_now(station, type, value) do
  %Pollutiondb.Reading{}
  |> Ecto.Changeset.cast(%{date: Date.utc_today, time: Time.utc_now, type: type, value: value},
     [:date, :time, :type, :value])
  |> Ecto.Changeset.validate_required([:date, :time, :type, :value])
  |> Ecto.Changeset.put_assoc(:station, station)
  |> Pollutiondb.Repo.insert()
  end

  def find_by_date(date) do
    Pollutiondb.Repo.all(
      Ecto.Query.where(Pollutiondb.Reading, date: ^date)
    )
  end

  def add(station, date, time, type, value) do
    %Pollutiondb.Reading{}
    |> Ecto.Changeset.cast(%{date: date, time: time, type: type, value: value},
         [:date, :time, :type, :value])
    |> Ecto.Changeset.validate_required([:date, :time, :type, :value])
    |> Ecto.Changeset.put_assoc(:station, station)
    |> Pollutiondb.Repo.insert(on_conflict: :nothing, conflict_target: [:station_id, :date, :time, :type])
  end
end