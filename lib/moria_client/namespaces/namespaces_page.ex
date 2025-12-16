defmodule MoriaClient.Namespaces.NamespacesPage do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          page: MoriaClient.Common.PageInfo.t(),
          namespaces: [MoriaClient.Namespaces.Namespace.t()]
        }

  @primary_key false
  embedded_schema do
    embeds_one :page, MoriaClient.Common.PageInfo
    embeds_many :namespaces, MoriaClient.Namespaces.Namespace
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:page)
    |> Ecto.Changeset.cast_embed(:namespaces)
  end
end
