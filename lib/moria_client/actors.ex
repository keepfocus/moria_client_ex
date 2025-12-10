defmodule MoriaClient.Actors do
  alias MoriaClient.Common
  alias MoriaClient.Helpers

  # alias MoriaClient.Actors.ActorsPage
  # actor list currently not implemented by Moria's v1 API
  # def list_actors(client, opts) do
  # end

  def get_actor(client, actor_id) do
    url = "/api/v1/actors/#{actor_id}"
    req = [method: :get, url: url]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body["actor"], MoriaClient.Actors.Actor)
    end
  end

  def get_current_actor(client) do
    url = "/api/v1/me"
    req = [method: :get, url: url]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body["actor"], MoriaClient.Actors.Actor)
    end
  end

  def create_actor(client, params) do
    url = "/api/v1/actors"
    req = [method: :post, url: url, body: %{actor: params}]

    with {:ok, env} <- Common.request(client, req, [201]) do
      Helpers.to_schema(env.body["actor"], MoriaClient.Actors.Actor)
    end
  end

  def update_actor(client, actor_id, params) do
    url = "/api/v1/actors/#{actor_id}"
    req = [method: :put, url: url, body: %{actor: params}]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body["actor"], MoriaClient.Actors.Actor)
    end
  end

  def delete_actor(client, actor_id) do
    url = "/api/v1/actors/#{actor_id}"
    req = [method: :delete, url: url]

    with {:ok, _expected} <- Common.request(client, req, [204]) do
      :ok
    end
  end
end
