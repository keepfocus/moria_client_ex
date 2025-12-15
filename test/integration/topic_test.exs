defmodule Integration.TopicTest do
  use ExUnit.Case, async: true
  setup {Integration, :setup_client}

  # Topic APIs
  test "topics CRUD", ctx do
    {:ok, namespace} =
      MoriaClient.create_namespace(ctx.client, %{
        reference: "integration-test-topic-namespace-#{ctx.actor.id}"
      })

    topic_ref_1 = "integration-test-topic-#{ctx.actor.id}-1"
    topic_ref_2 = "integration-test-topic-#{ctx.actor.id}-2"

    {:ok, topic_1} =
      MoriaClient.create_topic(ctx.client, %{
        reference: topic_ref_1,
        namespace_id: namespace.id,
        metadata: [%{key: "foo", value: "bar"}]
      })

    assert topic_1.reference == topic_ref_1

    {:ok, topic_2} =
      MoriaClient.create_topic(ctx.client, %{
        reference: topic_ref_2,
        namespace_id: namespace.id,
        metadata: [%{key: "foo", value: "baz"}]
      })

    # can list topics and find created ones
    {:ok, page} = MoriaClient.list_topics(ctx.client)
    assert Enum.all?(page.topics, fn t -> t.id in [topic_1.id, topic_2.id] end)

    # can paginate topics
    assert {:ok, page_1} =
             MoriaClient.list_topics(ctx.client,
               first: 1,
               after: nil,
               filters: [%{field: :metadata, value: "foo"}]
             )

    assert page_1.page.has_next_page
    assert %{topics: [%{reference: ^topic_ref_1}]} = page_1

    # next page
    assert {:ok, page_2} =
             MoriaClient.list_topics(ctx.client,
               first: 1,
               after: page_1.page.end_cursor,
               filters: [%{field: :metadata, value: "foo"}]
             )

    refute page_2.page.has_next_page
    assert %{topics: [%{reference: ^topic_ref_2}]} = page_2

    # Can stream topics via stream_topics/2
    # (we set first: 1 to force multiple pages)
    assert [
             %{reference: ^topic_ref_1},
             %{reference: ^topic_ref_2}
           ] =
             MoriaClient.stream_topics!(ctx.client,
               first: 1,
               filters: [%{field: :metadata, value: "foo"}]
             )
             |> Enum.to_list()

    # can update topic
    {:ok, updated_topic} =
      MoriaClient.update_topic(ctx.client, topic_1.id, %{description: "updated"})

    assert updated_topic.description == "updated"

    # can get topic by id
    {:ok, topic_by_id} = MoriaClient.get_topic(ctx.client, topic_1.id)
    assert topic_by_id.id == topic_1.id
    assert topic_by_id.reference == topic_ref_1

    # can delete topic
    :ok = MoriaClient.delete_topic(ctx.client, topic_1.id)

    # deleted topic is no longer found
    {:error, _reason} = MoriaClient.get_topic(ctx.client, topic_1.id)
  end
end
