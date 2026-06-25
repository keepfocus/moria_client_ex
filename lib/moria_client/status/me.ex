defmodule MoriaClient.Status.Me do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          machine: MoriaClient.Machines.Machine.t() | nil,
          user: MoriaClient.Accounts.User.t() | nil
        }

  @primary_key false
  embedded_schema do
    embeds_one :machine, MoriaClient.Machines.Machine
    embeds_one :user, MoriaClient.Accounts.User
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, __schema__(:fields) -- __schema__(:embeds))
    |> Ecto.Changeset.cast_embed(:machine)
    |> Ecto.Changeset.cast_embed(:user)
  end
end
