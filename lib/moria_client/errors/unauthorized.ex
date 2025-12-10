defmodule MoriaClient.Errors.Unauthorized do
  defstruct []

  def from_env!(%{status: 401}) do
    %__MODULE__{}
  end
end
