defmodule MoriaClient.Schema do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @timestamps_opts [type: :utc_datetime_usec]
      @primary_key {:id, :binary_id, autogenerate: false}
      @foreign_key_type :string
    end
  end
end
