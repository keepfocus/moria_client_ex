defmodule MoriaClient.Common do
  alias MoriaClient.Helpers

  @doc """
  wraps Tesla.request/2, but handles common error cases if the response status is not as expected
  """
  def request(client, request_opts, expected_status \\ 200) do
    expected_status = List.wrap(expected_status)

    case Tesla.request(client, request_opts) do
      {:ok, env} ->
        if env.status in expected_status do
          {:ok, env}
        else
          Helpers.handle_common_errors(env)
        end
    end
  end
end
