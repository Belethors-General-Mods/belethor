defmodule Crawler.SearchProvider do
  @module_doc "beaviour to implement search providers for `Crawler.TaskManager`"
  @type search_result() :: list(any())
  @type query :: list(any())
  @callback search(query()) :: search_result()
end
