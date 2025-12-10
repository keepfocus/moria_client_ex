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
end
