defmodule MoriaClient.Actors.ActorsPage do
  use MoriaClient.Schema

  @primary_key false
  embedded_schema do
    embeds_one :page_info, MoriaClient.Common.PageInfo
    embeds_many :actors, MoriaClient.Actors.Actor
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:page_info)
    |> Ecto.Changeset.cast_embed(:actors)
  end
end
