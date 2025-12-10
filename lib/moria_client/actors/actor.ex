defmodule MoriaClient.Actors.Actor do
  use MoriaClient.Schema

  embedded_schema do
    field :name, :string
    field :description, :string
    field :inserted_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec
    field :token, :string, default: nil
    embeds_many :accesses, MoriaClient.Namespaces.NamespaceAccess
  end

  def changeset(namespace \\ %__MODULE__{}, attrs) do
    namespace
    |> Ecto.Changeset.cast(attrs, [:id, :name, :description, :inserted_at, :updated_at, :token])
    |> Ecto.Changeset.cast_embed(:accesses)
  end
end
