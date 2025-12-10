defmodule MoriaClient do
  @moduledoc """
  Documentation for `MoriaClient`.
  """

  @type error ::
          MoriaClient.Errors.BadRequest.t()
          | MoriaClient.Errors.Unauthorized.t()
          | MoriaClient.Errors.Forbidden.t()
          | MoriaClient.Errors.NotFound.t()
          | MoriaClient.Errors.Conflict.t()
          | MoriaClient.Errors.InternalServerError.t()

  @type t :: Tesla.Client.t()

  ##
  ## Actors
  ##
  # NOT IMPLEMENTED:
  # defdelegate list_actors(client, opts \\ []), to: MoriaClient.Actors
  defdelegate get_actor(client, actor_id), to: MoriaClient.Actors
  defdelegate get_current_actor(client), to: MoriaClient.Actors
  defdelegate create_actor(client, params), to: MoriaClient.Actors
  defdelegate update_actor(client, id, params), to: MoriaClient.Actors
  defdelegate delete_actor(client, id), to: MoriaClient.Actors

  ##
  ## Namespaces
  ##
  defdelegate list_namespaces(client, opts \\ []), to: MoriaClient.Namespaces
  defdelegate stream_namespaces!(client, opts \\ []), to: MoriaClient.Namespaces
  defdelegate get_namespace(client, namespace_id), to: MoriaClient.Namespaces
  defdelegate create_namespace(client, params), to: MoriaClient.Namespaces
  defdelegate delete_namespace(client, id), to: MoriaClient.Namespaces

  ##
  ## Topics
  ##
  defdelegate list_topics(client, opts \\ []), to: MoriaClient.Topics
  defdelegate stream_topics!(client, opts \\ []), to: MoriaClient.Topics
  defdelegate get_topic(client, topic_id), to: MoriaClient.Topics
  defdelegate create_topic(client, params), to: MoriaClient.Topics
  defdelegate update_topic(client, topic_id, params), to: MoriaClient.Topics
  defdelegate delete_topic(client, topic_id), to: MoriaClient.Topics

  ##
  ## Encryption Keys
  ##
  defdelegate list_encryption_keys(client, namespace_id, opts \\ []),
    to: MoriaClient.EncryptionKeys

  defdelegate get_encryption_key(client, namespace_id, key_id),
    to: MoriaClient.EncryptionKeys

  defdelegate create_encryption_key(client, namespace_id, params),
    to: MoriaClient.EncryptionKeys

  defdelegate update_encryption_key(client, namespace_id, key_id, params),
    to: MoriaClient.EncryptionKeys

  defdelegate delete_encryption_key(client, namespace_id, key_id),
    to: MoriaClient.EncryptionKeys

  ##
  ## Messages
  ##

  defdelegate list_messages(client, topic_id, opts \\ []), to: MoriaClient.Messages
  defdelegate stream_messages!(client, topic_id, opts \\ []), to: MoriaClient.Messages
  defdelegate create_messages(client, params), to: MoriaClient.Messages

  ##
  ## Health
  ##

  defdelegate status(client), to: MoriaClient.Status

  ##
  ## Helpers
  ##
  @spec client(Keyword.t()) :: MoriaClient.t()
  def client(opts \\ []) do
    config = config(opts)
    version = Application.spec(:moria_client, :vsn) |> to_string()
    elixir_version = System.version()

    Tesla.client(
      [
        # base URL for all requests
        {Tesla.Middleware.BaseUrl, Keyword.fetch!(config, :base_url)},
        # default headers
        {Tesla.Middleware.Headers,
         [{"user-agent", "moria_client/#{version} Elixir/#{elixir_version}"}]},
        # encode/decode JSON
        {Tesla.Middleware.JSON, engine: JSON},
        # authentication
        case Keyword.get(config, :auth) do
          {:bearer, token} -> {Tesla.Middleware.BearerAuth, token: token}
          _ -> nil
        end,
        if opts[:trace] do
          Tesla.Middleware.Logger
        end,
        Tesla.Middleware.Telemetry
      ]
      |> Enum.reject(&is_nil/1),
      opts[:adapter] || Tesla.Adapter.Mint
    )
  end

  @doc """
  Returns the merged configuration as used by `client/1`.
  """
  @spec config(Keyword.t()) :: Keyword.t()
  def config(opts) do
    default_config()
    |> Keyword.merge(Application.get_all_env(:moria_client))
    |> Keyword.merge(opts)
  end

  @doc """
  Returns the default configuration for a `MoriaClient`
  before merging with Application config or user overrides.
  """
  @spec default_config() :: Keyword.t()
  def default_config() do
    [
      base_url: "http://localhost:4000",
      trace: false
    ]
  end
end
