defmodule Crawler.Provider do
  @moduledoc """
  behaviour to implemented a provider.
  `use` this module to implement the callbacks the standard way.

  If you `use` this module, a `Crawler.TaskManager` is expected run as `__YOUR_MODULE__.TaskManager`
  and a `Crawler.Client` should be implemented at `__YOUR_MODULE__.Client`
  """
  alias Common.Schema.Mod
  alias Crawler.Client

  @doc "do a remote search, may return a error tuple"
  @callback search(Client.args()) :: Client.result()
  @doc "do a remote search, throws on error"
  @callback search!(Client.args()) :: [%Mod{}]

  defmacro __using__(_args) do
    quote do
      alias Crawler.Provider
      alias Crawler.TaskManager
      @behaviour Provider

      @impl Provider
      def search(query) do
        TaskManager.search(query, __MODULE__.TaskManager, __MODULE__.Client)
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
