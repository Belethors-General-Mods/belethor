defmodule Crawler.Client do
  @moduledoc """
  beaviour to implement search providers for `Crawler.TaskManager`

  the implementations are meant to download and parse
  """
  @type result() :: any()
  @type search_result() :: {:ok, search_result()} | {:error, term()}
  @type query :: list(any())
  @callback search(query()) :: search_result()
end
