defmodule Crawler.Provider do
  @moduledoc """
  behaviour to implemented a provider.
  `use` this module to implement the callbacks the standard way.
  """
  alias Crawler.Client

  @doc "do a remote search, may return a error tuple"
  @callback search(Client.query()) :: Client.search_result()
  @doc "do a remote search, throws on error"
  @callback search!(Client.query()) :: [Client.result()]

  defmacro __using__(args) do
    name = args[:name]
    mgn = Module.concat([:Crawler, name, :TaskManager])
    cln = Module.concat([:Crawler, name, :Client])

    quote do
      alias Crawler.TaskManager
      alias Crawler.Provider
      @behaviour Provider

      @impl Provider
      def search(query) do
        TaskManager.search(query, unquote(mgn), unquote(cln))
      end

      @impl Provider
      def search!(query) do
        case search(query) do
          {:ok, result} -> result
          {:error, reason} -> throw(reason)
        end
      end
    end
  end
end
