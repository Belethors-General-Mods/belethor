defmodule Crawler.Provider do
  @callback search(Crawler.Client.query()) :: Crawler.Client.search_result()
  @callback search!(Crawler.Client.query()) :: [Crawler.Client.result()]

  defmacro __using__(args) do
    name = args[:name]
    mgn = Module.concat([:Crawler, name, :TaskManager])
    cln = Module.concat([:Crawler, name, :Client])

    quote do
      @behaviour Crawler.Provider

      @impl Crawler.Provider
      def search(query) do
        Crawler.TaskManager.search(query, unquote(mgn), unquote(cln))
      end

      @impl Crawler.Provider
      def search!(query) do
        case search(query) do
          {:ok, result} -> result
          {:error, reason} -> throw(reason)
        end
      end
    end
  end
end
