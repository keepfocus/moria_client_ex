defmodule MoriaClient.Errors.InternalServerError do
  defstruct [:env]

  def from_env!(%{status: 500} = env) do
    %__MODULE__{env: env}
  end
end
