defmodule Pollutiondb.Station do
  require Ecto.Query
  use Ecto.Schema

  schema "stations" do
    field :name, :string
    field :lon, :float
    field :lat, :float
    field :external_id, :string
    has_many :readings, Pollutiondb.Reading
  end

  def add(station) do
    Pollutiondb.Repo.insert(station)
  end

  def get_all() do
    Pollutiondb.Repo.all(Pollutiondb.Station)
  end

  def get_by_id(id) do
    Pollutiondb.Repo.get(Pollutiondb.Station, id)
  end

  def remove(station) do
    Pollutiondb.Repo.delete(station)
  end

  def find_by_name(name) do
    Pollutiondb.Repo.all(
      Ecto.Query.where(Pollutiondb.Station, name: ^name) )
  end

  def find_by_location(lon, lat) do
    Ecto.Query.from(s in Pollutiondb.Station,
      where: s.lon == ^lon,
      where: s.lat == ^lat)
    |> Pollutiondb.Repo.all
  end

  def find_by_location_range(lon_min, lon_max, lat_min, lat_max) do
    Ecto.Query.from(s in Pollutiondb.Station,
      where: s.lon < ^lon_max,
      where: s.lon > ^lon_min,
      where: s.lat < ^lat_max,
      where: s.lat > ^lat_min)
    |> Pollutiondb.Repo.all
  end

  def update_name(station, newname) do
    station
    |> changeset(%{name: newname})
    |> Pollutiondb.Repo.update()
  end

  def add(name, lon, lat) do
    %Pollutiondb.Station{}
    |> changeset(%{name: name, lat: lat, lon: lon})
    |> Pollutiondb.Repo.insert()
  end

  def insert_or_get(external_id, name, lon, lat) do
    %Pollutiondb.Station{}
    |> changeset(%{name: name, lon: lon, lat: lat})
    |> Ecto.Changeset.cast(%{external_id: external_id}, [:external_id])
    |> Ecto.Changeset.validate_required([:external_id])
    |> Pollutiondb.Repo.insert(on_conflict: :nothing, conflict_target: [:external_id])

    Pollutiondb.Repo.get_by!(Pollutiondb.Station, external_id: external_id)
  end

  defp changeset(station, changesmap) do
    station
    |> Ecto.Changeset.cast(changesmap, [:name, :lat, :lon])
    |> Ecto.Changeset.validate_required([:name, :lat, :lon])
    |> Ecto.Changeset.validate_number(:lon, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> Ecto.Changeset.validate_number(:lat, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
  end

end