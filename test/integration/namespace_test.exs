defmodule Integration.NamespaceTest do
  use ExUnit.Case, async: true
  setup {Integration, :setup_client}
  setup {Integration, :setup_namespace}
  setup :setup_second_namespace

  defp setup_second_namespace(ctx) do
    {:ok, namespace_2, namespace_ref_2} = Integration.create_namespace(ctx)

    %{
      namespace_1: ctx.namespace,
      namespace_2: namespace_2,
      namespace_ref_1: ctx.namespace_ref,
      namespace_ref_2: namespace_ref_2
    }
  end

  # Namespace APIs
  test "namespace CRUD", ctx do
    namespace_1 = ctx.namespace_1
    namespace_2 = ctx.namespace_2
    namespace_ref_1 = ctx.namespace_ref_1
    namespace_ref_2 = ctx.namespace_ref_2

    assert namespace_1.reference == namespace_ref_1
    assert namespace_2.reference == namespace_ref_2

    # can stream namespaces and find created ones even in shared datasets
    streamed_refs =
      MoriaClient.stream_namespaces!(ctx.client, first: 50)
      |> Enum.map(& &1.reference)

    assert namespace_ref_1 in streamed_refs
    assert namespace_ref_2 in streamed_refs

    # can paginate namespaces
    assert {:ok, page_1} = MoriaClient.list_namespaces(ctx.client, first: 1, after: nil)
    assert length(page_1.namespaces) == 1
    assert page_1.page.has_next_page

    # next page
    assert {:ok, page_2} =
             MoriaClient.list_namespaces(ctx.client, first: 1, after: page_1.page.end_cursor)

    assert length(page_2.namespaces) == 1
    refute hd(page_1.namespaces).id == hd(page_2.namespaces).id

    # stream_namespaces!/2 works with default opts too
    assert MoriaClient.stream_namespaces!(ctx.client) |> Enum.take(1) |> length() == 1

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
