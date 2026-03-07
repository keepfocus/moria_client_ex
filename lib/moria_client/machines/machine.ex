defmodule MoriaClient.Machines.Machine do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t() | nil,
          actor_id: String.t() | nil,
          organization_id: String.t() | nil,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  embedded_schema do
    field :name, :string
    field :description, :string
    field :actor_id, :string
    field :organization_id, :string
    field :inserted_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec
  end

  def changeset(machine \\ %__MODULE__{}, attrs) do
    machine
    |> Ecto.Changeset.cast(attrs, [
      :id,
      :name,
      :description,
      :actor_id,
      :organization_id,
      :inserted_at,
      :updated_at
    ])
  end
end
