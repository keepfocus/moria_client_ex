defmodule MoriaClient.Topics.TopicDeviceSummaryEntry do
  use MoriaClient.Schema

  @type t :: %__MODULE__{
          dlms_flag_id: String.t(),
          obis_cat: String.t(),
          identification_number: String.t(),
          version: integer(),
          mbus_device_type: integer()
        }

  @primary_key false
  embedded_schema do
    field :dlms_flag_id, :string
    field :obis_cat, :string
    field :identification_number, :string
    field :version, :integer
    field :mbus_device_type, :integer
  end

  def changeset(page \\ %__MODULE__{}, attrs) do
    page
    |> Ecto.Changeset.cast(attrs, [
      :dlms_flag_id,
      :obis_cat,
      :identification_number,
      :version,
      :mbus_device_type
    ])
  end
end
