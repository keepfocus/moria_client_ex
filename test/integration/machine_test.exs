defmodule Integration.MachineTest do
  use ExUnit.Case, async: true
  setup {Integration, :setup_client}

  # Machine APIs
  test "machine read/update", ctx do
    # can get machine via id
    {:ok, machine_by_id} = MoriaClient.get_machine(ctx.client, ctx.machine.id)
    assert machine_by_id.id == ctx.machine.id

    # can update machine
    new_name = machine_by_id.name <> " Updated"

    {:ok, updated_machine} =
      MoriaClient.update_machine(ctx.client, ctx.machine.id, %{name: new_name})

    assert updated_machine.name == new_name
    assert updated_machine.id == ctx.machine.id
  end
end
