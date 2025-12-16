defmodule MoriaClient.EncryptionKeys.EncryptionKeysPage do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          page: MoriaClient.Common.PageInfo.t(),
          encryption_keys: [MoriaClient.EncryptionKeys.EncryptionKey.t()]
        }

  @primary_key false
  embedded_schema do
    embeds_one :page, MoriaClient.Common.PageInfo
    embeds_many :encryption_keys, MoriaClient.EncryptionKeys.EncryptionKey
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:page)
    |> Ecto.Changeset.cast_embed(:encryption_keys)
  end
end
