defmodule Integration do
  @super_credentials "moria-client-ex-super-credentials"

  def setup_client(_ctx) do
    datetime = DateTime.utc_now() |> DateTime.to_string()
    idx = :erlang.unique_integer([:positive])
    client = MoriaClient.client(auth: {:bearer, @super_credentials})

    {:ok, machine} =
      MoriaClient.create_machine(client, %{
        name: "MoriaClient integration test machine #{idx} - #{datetime}"
      })

    ExUnit.Callbacks.on_exit(fn ->
      :ok = MoriaClient.delete_machine(client, machine.id)
    end)

    %{machine: machine, client: client}
  end
end
