defmodule MoriaClient.Common.PageInfo do
  use MoriaClient.Schema

  @primary_key false
  embedded_schema do
    field :has_next_page, :boolean
    field :has_previous_page, :boolean
    field :start_cursor, :string
    field :end_cursor, :string
  end

  def changeset(page_info \\ %__MODULE__{}, attrs) do
    page_info
    |> Ecto.Changeset.cast(attrs, [
      :has_next_page,
      :has_previous_page,
      :start_cursor,
      :end_cursor
    ])
  end
end
