defmodule MoriaClient.Topics.Topic do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          reference: String.t(),
          description: String.t() | nil,
          namespace_id: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t(),
          metadata: [MoriaClient.Common.Metadata.t()]
        }

  embedded_schema do
    field :reference, :string
    field :description, :string
    field :namespace_id, :string
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
