defmodule MoriaClient.Errors.Conflict do
  alias MoriaClient.Common.FieldError
  defstruct [:errors]

  def from_env!(%{status: 409, body: %{"errors" => errors}}) do
    %__MODULE__{
      errors:
        Enum.flat_map(errors, fn {field, reasons} ->
          Enum.map(reasons, &FieldError.new(field, &1))
        end)
    }
  end
end
