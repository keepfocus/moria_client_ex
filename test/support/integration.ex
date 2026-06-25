defmodule Integration do
  @super_credentials "moria-client-ex-super-credentials"

  def setup_client(_ctx) do
    datetime = DateTime.utc_now() |> DateTime.to_string()
    idx = :erlang.unique_integer([:positive])
    client = MoriaClient.client(auth: {:bearer, @super_credentials})
    {:ok, %{machine: %{organization_id: organization_id}}} = MoriaClient.me(client)

    {:ok, machine} =
      MoriaClient.create_machine(client, %{
        name: "MoriaClient integration test machine #{idx} - #{datetime}",
        organization_id: organization_id
      })

    ExUnit.Callbacks.on_exit(fn ->
      :ok = MoriaClient.delete_machine(client, machine.id)
    end)

    %{machine: machine, client: client}
  end

  def setup_namespace(ctx) do
    {:ok, namespace, namespace_ref} = create_namespace(ctx)

    %{namespace: namespace, namespace_ref: namespace_ref}
  end

  def create_namespace(ctx, prefix \\ "integration-test-namespace") do
    idx = :erlang.unique_integer([:positive])
    namespace_ref = "#{prefix}-#{ctx.machine.id}-#{idx}"

    {:ok, namespace} =
      MoriaClient.create_namespace(ctx.client, %{
        reference: namespace_ref,
        organization_id: ctx.machine.organization_id
      })

    ExUnit.Callbacks.on_exit(fn ->
      _ = MoriaClient.delete_namespace(ctx.client, namespace.id)
      :ok
    end)

    {:ok, namespace, namespace_ref}
  end
end
