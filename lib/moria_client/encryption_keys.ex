defmodule MoriaClient.EncryptionKeys do
  alias MoriaClient.Common
  alias MoriaClient.Helpers

  def list_encryption_keys(client, namespace_id, opts) do
    url = "/api/v1/namespaces/#{namespace_id}/encryption_keys"
    req = [method: :get, url: url, query: Helpers.to_query(opts)]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body, MoriaClient.EncryptionKeys.EncryptionKeysPage)
    end
  end

  def get_encryption_key(client, namespace_id, key_id) do
    url = "/api/v1/namespaces/#{namespace_id}/encryption_keys/#{key_id}"
    req = [method: :get, url: url]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body["encryption_key"], MoriaClient.EncryptionKeys.EncryptionKey)
    end
  end

  def create_encryption_key(client, namespace_id, params) do
    url = "/api/v1/namespaces/#{namespace_id}/encryption_keys"
    opts = [method: :post, url: url, body: %{encryption_key: params}]

    with {:ok, env} <- Common.request(client, opts, [201]) do
      Helpers.to_schema(env.body["encryption_key"], MoriaClient.EncryptionKeys.EncryptionKey)
    end
  end

  def update_encryption_key(client, namespace_id, key_id, params) do
    url = "/api/v1/namespaces/#{namespace_id}/encryption_keys/#{key_id}"
    opts = [method: :put, url: url, body: %{encryption_key: params}]

    with {:ok, env} <- Common.request(client, opts, [200]) do
      Helpers.to_schema(env.body["encryption_key"], MoriaClient.EncryptionKeys.EncryptionKey)
    end
  end

  def delete_encryption_key(client, namespace_id, key_id) do
    url = "/api/v1/namespaces/#{namespace_id}/encryption_keys/#{key_id}"

    with {:ok, _expected} <- Common.request(client, [method: :delete, url: url], [204]) do
      :ok
    end
  end
end
