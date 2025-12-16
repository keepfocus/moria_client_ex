defmodule MoriaClient.Messages.MessagesPage do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          page: MoriaClient.Common.PageInfo.t(),
          messages: [MoriaClient.Messages.Message.t()],
          topic: MoriaClient.Topics.Topic.t()
        }

  @primary_key false
  embedded_schema do
    embeds_one :page, MoriaClient.Common.PageInfo
    embeds_many :messages, MoriaClient.Messages.Message
    embeds_one :topic, MoriaClient.Topics.Topic
    # TODO: kv
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, [])
    |> Ecto.Changeset.cast_embed(:page)
    |> Ecto.Changeset.cast_embed(:topic)
    |> Ecto.Changeset.cast_embed(:messages)
  end
end
