defmodule Crawler.Client do
  @moduledoc """
  beaviour to implement search providers for `Crawler.TaskManager`

  the implementations are meant to download and parse
  """
  @type result() :: any()
  @type search_result() :: {:ok, [mod()]} | {:error, term()}
  @type query :: list(any())
  @callback search(query()) :: search_result()

  #TODO :)
  @type mod() :: :todo
end
