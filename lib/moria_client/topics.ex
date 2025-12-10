defmodule MoriaClient.Topics do
  alias MoriaClient.Common
  alias MoriaClient.Helpers

  def list_topics(client, opts) do
    url = "/api/v1/topics"
    req = [method: :get, url: url, query: Helpers.flop_query(opts)]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body, MoriaClient.Topics.TopicsPage)
    end
  end

  def stream_topics!(client, opts) do
    Helpers.stream_pages(&list_topics(client, &1), opts)
    |> Stream.flat_map(& &1.topics)
  end

  def get_topic(client, topic_id) do
    url = "/api/v1/topics/#{topic_id}"
    req = [method: :get, url: url]

    with {:ok, env} <- Common.request(client, req, [200]) do
      Helpers.to_schema(env.body["topic"], MoriaClient.Topics.Topic)
    end
  end

  def create_topic(client, params) do
    url = "/api/v1/topics"
    opts = [method: :post, url: url, body: %{topic: params}]

    with {:ok, env} <- Common.request(client, opts, [201]) do
      Helpers.to_schema(env.body["topic"], MoriaClient.Topics.Topic)
    end
  end

  def update_topic(client, topic_id, params) do
    url = "/api/v1/topics/#{topic_id}"
    opts = [method: :put, url: url, body: %{topic: params}]

    with {:ok, env} <- Common.request(client, opts, [200]) do
      Helpers.to_schema(env.body["topic"], MoriaClient.Topics.Topic)
    end
  end

  def delete_topic(client, topic_id) do
    url = "/api/v1/topics/#{topic_id}"

    with {:ok, _expected} <- Common.request(client, [method: :delete, url: url], [204]) do
      :ok
    end
  end
end
