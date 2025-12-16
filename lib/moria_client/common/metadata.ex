defmodule MoriaClient.Common.Metadata do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key false
  embedded_schema do
    field :key, :string
    field :value, :string
    field :inserted_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec
  end

  def changeset(metadata \\ %__MODULE__{}, attrs) do
    metadata
    |> Ecto.Changeset.cast(attrs, [:key, :value, :inserted_at, :updated_at])
  end
end
