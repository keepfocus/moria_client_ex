defmodule Integration.ActorTest do
  use ExUnit.Case, async: true
  setup {Integration, :setup_client}

  # Actor APIs
  test "actor read/update", ctx do
    # can get current actor
    {:ok, actor} = MoriaClient.get_current_actor(ctx.client)
    assert actor.id == ctx.actor.id
    # can get same actor via id
    {:ok, actor_by_id} = MoriaClient.get_actor(ctx.client, ctx.actor.id)
    assert actor_by_id.id == ctx.actor.id
    # can update actor
    new_name = actor.name <> " Updated"
    {:ok, updated_actor} = MoriaClient.update_actor(ctx.client, ctx.actor.id, %{name: new_name})
    assert updated_actor.name == new_name
    assert updated_actor.id == ctx.actor.id
  end
end
