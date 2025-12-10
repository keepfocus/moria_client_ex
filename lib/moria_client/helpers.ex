defmodule MoriaClient.Helpers do
  @moduledoc false
  alias MoriaClient.Errors

  @doc """
  Convert a map or other data structure into an Ecto schema by applying the schema's changeset function
  """
  def to_schema(data, schema) when is_atom(schema) do
    data
    |> schema.changeset()
    |> Ecto.Changeset.apply_action(:validate_server_response)
  end

  def encode_filters(filters) when is_list(filters) do
    filters
    |> Enum.with_index()
    |> Enum.reduce([], fn {filter_map, idx}, acc ->
      Enum.reduce(filter_map, acc, fn {field, value}, acc ->
        [{"filters[#{idx}][#{field}]", to_string(value)} | acc]
      end)
    end)
  end

  def flop_filter_pairs(opts, key \\ :filter) when is_list(opts) do
    opts
    |> Keyword.filter(fn {k, _v} -> k == key end)
    |> Keyword.values()
    |> Enum.flat_map(fn
      [] -> []
      [{key, _value} | _] = filter when is_atom(key) -> [filter]
      [_ | _] = filters -> filters
      other -> [other]
    end)
    |> encode_filters()
  end

  def flop_pagination_pairs(opts) when is_list(opts) do
    opts
    |> Keyword.take([:first, :after, :last, :before, :limit, :offset, :page_size, :page])
    |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)
  end

  def flop_query(opts) do
    flop_filter_pairs(opts) ++ flop_pagination_pairs(opts)
  end

  def handle_common_errors(%{status: 400} = env),
    do: {:error, Errors.BadRequest.from_env!(env)}

  def handle_common_errors(%{status: 404} = env),
    do: {:error, Errors.NotFound.from_env!(env)}

  def handle_common_errors(%{status: 500} = env),
    do: {:error, Errors.InternalServerError.from_env!(env)}

  def handle_common_errors(%{status: 401} = env),
    do: {:error, Errors.Unauthorized.from_env!(env)}

  def handle_common_errors(%{status: 409} = env),
    do: {:error, Errors.Conflict.from_env!(env)}

  def handle_common_errors(%{status: 422} = env),
    do: {:error, Errors.Unprocessable.from_env!(env)}

  @doc """
  Stream paginated results from a page function that returns {:ok, page} tuples.

  This can be used with any function that takes a single opts argument and
  returns paginated results in the form of {:ok, page},
  where `page` contains a `page` map with `end_cursor` and `has_next_page` fields.

  This is commonly done with listing functions by `&MoriaClient.list_<resource>(client, &1)`.

  NOTE: This function throws `{:error, reason}` if it encounters an error from the page function.

  NOTE: This only works with forward pagination (using `after` cursors and `first` limits).
  """
  def stream_pages(page_fun, opts) do
    Stream.unfold(nil, fn
      :halt ->
        nil

      cursor ->
        pagination = if(cursor, do: [after: cursor], else: [])

        case page_fun.(Keyword.merge(opts, pagination)) do
          {:ok, %{page: %{end_cursor: next_cursor, has_next_page: has_next_page}} = page} ->
            {page, if(has_next_page, do: next_cursor, else: :halt)}

          {:error, reason} ->
            throw({:error, reason})
        end
    end)
  end
end
