defmodule Crawler.SearchProvider do
  @type search_result() :: list(any())
  @type query :: list(any())
  @callback search(query()) :: search_result()
end
