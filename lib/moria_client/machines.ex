defmodule MoriaClient.Machines do
  alias MoriaClient.Common
  alias MoriaClient.Helpers

  def get_machine(client, machine_id) do
    url = "/api/v1/machines/#{machine_id}"
    req = [method: :get, url: url]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body["machine"], MoriaClient.Machines.Machine)
    end
  end

  def create_machine(client, params) do
    url = "/api/v1/machines"
    req = [method: :post, url: url, body: %{machine: params}]

    with {:ok, env} <- Common.request(client, req, [201]) do
      Helpers.to_schema(env.body["machine"], MoriaClient.Machines.Machine)
    end
  end

  def update_machine(client, machine_id, params) do
    url = "/api/v1/machines/#{machine_id}"
    req = [method: :put, url: url, body: %{machine: params}]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body["machine"], MoriaClient.Machines.Machine)
    end
  end

  def delete_machine(client, machine_id) do
    url = "/api/v1/machines/#{machine_id}"
    req = [method: :delete, url: url]

    with {:ok, _expected} <- Common.request(client, req, [204]) do
      :ok
    end
  end
end
