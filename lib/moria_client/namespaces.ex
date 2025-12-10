defmodule MoriaClient.Namespaces do
  alias MoriaClient.Common
  alias MoriaClient.Helpers

  def list_namespaces(client, opts) do
    url = "/api/v1/namespaces"
    req = [method: :get, url: url, query: Helpers.flop_query(opts)]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body, MoriaClient.Namespaces.NamespacesPage)
    end
  end

  def stream_namespaces!(client, opts) do
    Helpers.stream_pages(&list_namespaces(client, &1), opts)
    |> Stream.flat_map(& &1.namespaces)
  end

  def get_namespace(client, namespace_id) do
    url = "/api/v1/namespaces/#{namespace_id}"
    req = [method: :get, url: url]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body["namespace"], MoriaClient.Namespaces.Namespace)
    end
  end

  def create_namespace(client, params) do
    url = "/api/v1/namespaces"
    opts = [method: :post, url: url, body: %{namespace: params}]

    with {:ok, env} <- Common.request(client, opts, [201]) do
      Helpers.to_schema(env.body["namespace"], MoriaClient.Namespaces.Namespace)
    end
  end

  def update_namespace(client, namespace_id, params) do
    url = "/api/v1/namespaces/#{namespace_id}"
    opts = [method: :put, url: url, body: %{namespace: params}]

    with {:ok, env} <- Common.request(client, opts, [200]) do
      Helpers.to_schema(env.body["namespace"], MoriaClient.Namespaces.Namespace)
    end
  end

  def delete_namespace(client, namespace_id) do
    url = "/api/v1/namespaces/#{namespace_id}"

    with {:ok, _expected} <- Common.request(client, [method: :delete, url: url], [204]) do
      :ok
    end
  end
end
