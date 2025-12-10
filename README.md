# MoriaClient

API client for the Moria log storage service.  
This code-base is useless without access to a Moria server.

## Installation

The package can be installed by adding `moria_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # From hex:
    {:moria_client, "~> 0.1.0"}

    # Or from github:
    {:moria_client, git: "https://github.com/keepfocus/moria_client_ex.git", branch: "main"},
  ]
end
```

## Usage

```elixir

client = MoriaClient.client(auth: {:bearer, my_token})

{:ok, namespaces_page} = MoriaClient.list_namespaces(client, first: 10)
```