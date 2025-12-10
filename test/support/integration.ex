defmodule Integration do
  def setup_client(_ctx) do
    datetime = DateTime.utc_now() |> DateTime.to_string()
    idx = :erlang.unique_integer([:positive])

    {:ok, actor} =
      MoriaClient.create_actor(MoriaClient.client(), %{
        name: "MoriaClient integration test actor #{idx} - #{datetime}"
      })

    client = MoriaClient.client(auth: {:bearer, actor.token})

    ExUnit.Callbacks.on_exit(fn ->
      :ok = MoriaClient.delete_actor(client, actor.id)
    end)

    %{actor: actor, client: client}
  end
end
