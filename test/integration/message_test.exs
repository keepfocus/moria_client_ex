defmodule Integration.MessageTest do
  use ExUnit.Case, async: true
  setup {Integration, :setup_client}

  # Message APIs
  test "message CRUD", ctx do
    {:ok, namespace} =
      MoriaClient.create_namespace(ctx.client, %{
        reference: "integration-test-message-namespace-#{ctx.actor.id}"
      })

    on_exit(fn ->
      :ok = MoriaClient.delete_namespace(ctx.client, namespace.id)
    end)

    {:ok, topic_a} =
      MoriaClient.create_topic(ctx.client, %{
        reference: "integration-test-message-topic-a-#{ctx.actor.id}",
        namespace_id: namespace.id
      })

    {:ok, topic_b} =
      MoriaClient.create_topic(ctx.client, %{
        reference: "integration-test-message-topic-b-#{ctx.actor.id}",
        namespace_id: namespace.id
      })

    assert {:ok, page} =
             MoriaClient.create_messages(ctx.client, [
               %{topic_id: topic_a.id, payload: "1", payload_type: "text/plain"},
               %{topic_id: topic_a.id, payload: "2", payload_type: "text/plain"},
               %{topic_id: topic_a.id, payload: "3", payload_type: "text/plain"},
               %{topic_id: topic_b.id, payload: "foo", payload_type: "text/plain"},
               %{topic_id: topic_a.id, payload: "4", payload_type: "text/plain"}
             ])

    assert length(page.messages) == 5

    topic_a_id = topic_a.id
    topic_b_id = topic_b.id

    # assert order returned is order given
    assert [
             %{id: id1, topic_id: ^topic_a_id},
             %{id: id2, topic_id: ^topic_a_id},
             %{id: id3, topic_id: ^topic_a_id},
             %{id: _id4, topic_id: ^topic_b_id},
             %{id: id5, topic_id: ^topic_a_id}
           ] = page.messages

    # check we can list per topic:
    assert {:ok, topic_b_page} = MoriaClient.list_messages(ctx.client, topic_b.id)
    assert length(topic_b_page.messages) == 1
    assert topic_b_page.topic.id == topic_b.id

    # pagination:
    assert {:ok, topic_a_page} = MoriaClient.list_messages(ctx.client, topic_a.id, first: 3)
    assert length(topic_a_page.messages) == 3
    assert topic_a_page.topic.id == topic_a.id
    assert topic_a_page.messages |> Enum.all?(fn m -> m.topic_id == topic_a.id end)
    # assert insert order is also listed order
    assert [id1, id2, id3] == Enum.map(topic_a_page.messages, & &1.id)

    # next page
    cursor = topic_a_page.page.end_cursor

    assert {:ok, paged_page} =
             MoriaClient.list_messages(ctx.client, topic_a.id, first: 3, after: cursor)

    # can stream messages via stream_messages/3
    assert [
             %{id: ^id1},
             %{id: ^id2},
             %{id: ^id3},
             %{id: ^id5}
           ] =
             MoriaClient.stream_messages!(ctx.client, topic_a.id, first: 3)
             |> Enum.to_list()

    # the final message should be on this page
    assert length(paged_page.messages) == 1
    assert [id5] == Enum.map(paged_page.messages, & &1.id)
  end
end
