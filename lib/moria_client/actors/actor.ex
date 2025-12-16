defmodule MoriaClient.Actors.Actor do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t(),
          token: String.t() | nil,
          accesses: [MoriaClient.Namespaces.NamespaceAccess.t()]
        }

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
