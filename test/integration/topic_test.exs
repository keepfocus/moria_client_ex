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
      MoriaClient.create_topic(ctx.client, %{reference: topic_ref_1, namespace_id: namespace.id})

    assert topic_1.reference == topic_ref_1

    {:ok, topic_2} =
      MoriaClient.create_topic(ctx.client, %{reference: topic_ref_2, namespace_id: namespace.id})

    # can list topics and find created ones
    {:ok, page} = MoriaClient.list_topics(ctx.client)
    assert Enum.all?(page.topics, fn t -> t.id in [topic_1.id, topic_2.id] end)

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
