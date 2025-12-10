defmodule Integration.NamespaceTest do
  use ExUnit.Case, async: true
  setup {Integration, :setup_client}

  # Namespace APIs
  test "namespace CRUD", ctx do
    namespace_ref_1 = "integration-test-namespace-#{ctx.actor.id}-1"
    namespace_ref_2 = "integration-test-namespace-#{ctx.actor.id}-2"
    {:ok, namespace_1} = MoriaClient.create_namespace(ctx.client, %{reference: namespace_ref_1})
    assert namespace_1.reference == namespace_ref_1
    {:ok, namespace_2} = MoriaClient.create_namespace(ctx.client, %{reference: namespace_ref_2})

    # can list namespaces and find created ones
    {:ok, page} = MoriaClient.list_namespaces(ctx.client)
    assert Enum.all?(page.namespaces, fn ns -> ns.id in [namespace_1.id, namespace_2.id] end)

    # can paginate namespaces
    assert {:ok, page_1} = MoriaClient.list_namespaces(ctx.client, first: 1, after: nil)
    assert page_1.page.has_next_page
    assert %{namespaces: [%{reference: ^namespace_ref_1}]} = page_1
    # next page
    assert {:ok, page_2} =
             MoriaClient.list_namespaces(ctx.client, first: 1, after: page_1.page.end_cursor)

    refute page_2.page.has_next_page
    assert %{namespaces: [%{reference: ^namespace_ref_2}]} = page_2

    # can stream namespaces via stream_namespaces/2
    # (we set first: 1 to force multiple pages)
    assert [
             %{reference: ^namespace_ref_1},
             %{reference: ^namespace_ref_2}
           ] =
             MoriaClient.stream_namespaces!(ctx.client, first: 1)
             |> Enum.to_list()

    # (also works with default opts)
    assert [
             %{reference: ^namespace_ref_1},
             %{reference: ^namespace_ref_2}
           ] =
             MoriaClient.stream_namespaces!(ctx.client)
             |> Enum.to_list()

    # can update namespace
    new_reference = namespace_1.reference <> "-updated"

    {:ok, updated_namespace} =
      MoriaClient.Namespaces.update_namespace(ctx.client, namespace_1.id, %{
        reference: new_reference
      })

    assert updated_namespace.reference == new_reference

    # can get namespace by id
    {:ok, namespace_by_id} = MoriaClient.get_namespace(ctx.client, namespace_1.id)
    assert namespace_by_id.id == namespace_1.id
    assert namespace_by_id.reference == new_reference

    # can delete namespace
    :ok = MoriaClient.delete_namespace(ctx.client, namespace_1.id)

    # deleted namespace is no longer found
    {:error, _reason} = MoriaClient.get_namespace(ctx.client, namespace_1.id)
  end
end
