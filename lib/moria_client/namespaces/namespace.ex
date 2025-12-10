defmodule MoriaClient.Namespaces.Namespace do
  use MoriaClient.Schema

  embedded_schema do
    field :reference, :string
    field :inserted_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec
    embeds_many :metadata, MoriaClient.Common.Metadata
  end

  def changeset(namespace \\ %__MODULE__{}, attrs) do
    namespace
    |> Ecto.Changeset.cast(attrs, __schema__(:fields) -- __schema__(:embeds))
    |> Ecto.Changeset.cast_embed(:metadata)
  end
end
