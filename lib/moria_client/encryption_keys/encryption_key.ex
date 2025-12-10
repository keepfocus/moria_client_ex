defmodule MoriaClient.EncryptionKeys.EncryptionKey do
  use MoriaClient.Schema

  embedded_schema do
    field :namespace_id, :string
    field :identification_number, :string
    field :dlms_flag_id, :string
    # base16 encoded key
    field :key, :string
  end

  def changeset(encryption_key \\ %__MODULE__{}, attrs) do
    encryption_key
    |> Ecto.Changeset.cast(attrs, __schema__(:fields) -- __schema__(:embeds))
  end
end
