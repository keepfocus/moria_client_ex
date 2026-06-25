defmodule MoriaClient.Topics.TopicDeviceSummaryPage do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          topic_id: String.t(),
          devices: [MoriaClient.Topics.TopicDeviceSummaryPage.DeviceEntry.t()]
        }

  @primary_key false
  embedded_schema do
    field :topic_id, :integer
    embeds_many :devices, __MODULE__.DeviceEntry
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, __schema__(:fields) -- __schema__(:embeds))
    |> Ecto.Changeset.cast_embed(:devices)
  end

  defmodule DeviceEntry do
    use MoriaClient.Schema

    @type t :: %__MODULE__{}

    @primary_key false
    embedded_schema do
      embeds_one :identification, MoriaClient.Common.Identification
    end

    def changeset(page \\ %__MODULE__{}, attrs) do
      page
      |> Ecto.Changeset.cast(attrs, __schema__(:fields) -- __schema__(:embeds))
      |> Ecto.Changeset.cast_embed(:identification)
    end
  end
end
