defmodule MoriaClient.Messages.Message do
  use MoriaClient.Schema

  embedded_schema do
    field :inserted_at, :utc_datetime_usec
    field :captured_at, :utc_datetime_usec
    field :payload_type_id, :string
    field :payload_size, :integer
    field :topic_id, :string
    field :components, :map, default: %{}, virtual: false
  end

  def changeset(namespace \\ %__MODULE__{}, attrs) do
    namespace
    |> Ecto.Changeset.cast(attrs, __schema__(:fields) -- __schema__(:embeds))
  end
end
