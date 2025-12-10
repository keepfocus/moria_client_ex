defmodule MoriaClient.Common.FieldError do
  defstruct [:field, :reason]

  def new(field, reason) do
    %__MODULE__{field: field, reason: reason}
  end
end
