defmodule MoriaClient.Status.StatusInfo do
  use MoriaClient.Schema

  @primary_key false
  embedded_schema do
    field :authorized, :boolean
    field :status, Ecto.Enum, values: [ok: "OK"]
    field :server_version, :string
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, __schema__(:fields) -- __schema__(:embeds))
  end
end
