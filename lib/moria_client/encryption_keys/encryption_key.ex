defmodule MoriaClient.EncryptionKeys.EncryptionKey do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          namespace_id: String.t(),
          identification_number: String.t(),
          dlms_flag_id: String.t(),
          key: String.t()
        }

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
