defmodule MoriaClient.Namespaces.NamespaceAccess do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          namespace_id: String.t(),
          actor_id: String.t(),
          read: boolean(),
          write: boolean(),
          delegate: boolean()
        }

  embedded_schema do
    field :namespace_id, :string
    field :actor_id, :string
    field :read, :boolean
    field :write, :boolean
    field :delegate, :boolean
  end

  def changeset(namespace \\ %__MODULE__{}, attrs) do
    namespace
    |> Ecto.Changeset.cast(attrs, [
      :id,
      :namespace_id,
      :actor_id,
      :read,
      :write,
      :delegate
    ])
  end
end
