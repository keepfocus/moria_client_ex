defmodule MoriaClient.Topics.TopicDeviceSummaryPage do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          range: String.t(),
          processed: integer(),
          missing: integer(),
          failed: integer(),
          identified: integer(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t(),
          devices: [MoriaClient.Topics.TopicDeviceSummaryPage.DeviceEntry.t()]
        }

  @primary_key false
  embedded_schema do
    field :range, :string
    field :processed, :integer
    field :missing, :integer
    field :failed, :integer
    field :identified, :integer
    field :inserted_at, :utc_datetime_usec
    field :updated_at, :utc_datetime_usec
    embeds_many :devices, __MODULE__.DeviceEntry
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, [
      :range,
      :processed,
      :missing,
      :failed,
      :identified,
      :inserted_at,
      :updated_at
    ])
    |> Ecto.Changeset.cast_embed(:devices)
  end

  defmodule DeviceEntry do
    use MoriaClient.Schema

    @type t :: %__MODULE__{}

    @primary_key false
    embedded_schema do
      embeds_one :identification, MoriaClient.Common.Identification
      field :key, :string
      field :min_id, :integer
      field :min_id_timestamp, :utc_datetime_usec
      field :max_id, :integer
      field :max_id_timestamp, :utc_datetime_usec
      field :count, :integer
    end

    def changeset(page \\ %__MODULE__{}, attrs) do
      page
      |> Ecto.Changeset.cast(attrs, [
        :key,
        :min_id,
        :min_id_timestamp,
        :max_id,
        :max_id_timestamp,
        :count
      ])
      |> Ecto.Changeset.cast_embed(:identification)
    end
  end
end
