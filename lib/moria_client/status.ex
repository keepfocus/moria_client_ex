defmodule MoriaClient.Status do
  alias MoriaClient.Helpers

  @doc """
  Check the status of the Moria server.

  Returns a `t:MoriaClient.Status.StatusInfo.t()` struct on success.
  """
  @spec status(MoriaClient.t()) ::
          {:ok, MoriaClient.Status.StatusInfo.t()} | {:error, MoriaClient.error()}
  def status(client) do
    url = "/healthz"
    req = [method: :get, url: url]

    with {:ok, env} <- MoriaClient.Common.request(client, req, [200]) do
      Helpers.to_schema(env.body, MoriaClient.Status.StatusInfo)
    end
  end
end
