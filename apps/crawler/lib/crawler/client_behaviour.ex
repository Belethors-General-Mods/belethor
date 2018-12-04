defmodule Crawler.Client do
  @moduledoc """
  This module describes client behaviour to be used by `Crawler.TaskManager.search/4`.

  The implementations are meant to download and parse.
  """
  @type result() :: any()
  @type search_result() :: {:ok, [mod()]} | {:error, term()}
  @type query :: list(any())
  @callback search(query()) :: search_result()

  #TODO :)
  @type mod() :: :todo
end
