defmodule MoriaClient.Messages do
  alias MoriaClient.Helpers

  def create_messages(client, messages_params) when is_list(messages_params) do
    url = "/api/v1/messages"
    opts = [method: :post, url: url, body: %{messages: messages_params}]

    with {:ok, env} <- MoriaClient.Common.request(client, opts, [201]) do
      MoriaClient.Helpers.to_schema(env.body, MoriaClient.Messages.MessagesPage)
    end
  end

  def list_messages(client, topic_id, opts \\ []) do
    url = "/api/v1/topics/#{topic_id}/messages"
    req = [method: :get, url: url, query: Helpers.flop_query(opts)]

    with {:ok, env} <- MoriaClient.Common.request(client, req, [200]) do
      MoriaClient.Helpers.to_schema(env.body, MoriaClient.Messages.MessagesPage)
    end
  end

  def stream_messages!(client, topic_id, opts \\ []) do
    Helpers.stream_pages(&list_messages(client, topic_id, &1), opts)
    |> Stream.flat_map(& &1.messages)
  end
end
