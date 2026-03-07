defmodule Integration.EncryptionKeyTest do
  use ExUnit.Case, async: true
  setup {Integration, :setup_client}
  setup {Integration, :setup_namespace}

  # Encryption Key APIs
  test "encryption keys CRUD", ctx do
    namespace = ctx.namespace

    params = %{
      base16_key: "AABBCCDDEEFF00112233445566778899",
      identification_number: "12345678"
    }

    {:ok, key_1} = MoriaClient.create_encryption_key(ctx.client, namespace.id, params)
    assert key_1.identification_number == "12345678"

    # list
    {:ok, page} = MoriaClient.list_encryption_keys(ctx.client, namespace.id)
    assert Enum.all?(page.encryption_keys, fn k -> k.id == key_1.id end)
    # get by id
    {:ok, key_by_id} = MoriaClient.get_encryption_key(ctx.client, namespace.id, key_1.id)
    assert key_by_id.id == key_1.id
    # update
    {:ok, updated_key} =
      MoriaClient.update_encryption_key(ctx.client, namespace.id, key_1.id, %{
        identification_number: "87654321"
      })

    assert updated_key.identification_number == "87654321"

    # delete
    :ok = MoriaClient.delete_encryption_key(ctx.client, namespace.id, key_1.id)

    # deleted key is no longer found
    {:error, _reason} = MoriaClient.get_encryption_key(ctx.client, namespace.id, key_1.id)
  end
end
