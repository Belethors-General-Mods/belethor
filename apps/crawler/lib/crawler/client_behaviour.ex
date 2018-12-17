defmodule Crawler.Client do
  @moduledoc """
  This module describes client behaviour to be used by `Crawler.TaskManager.search/4`.

  The only function to be implemented is the `search/1` function.
  """
  @type result() :: any()
  @type search_result() :: {:ok, [mod()]} | {:error, term()}
  @type query :: list(any())
  @doc """
  This function is meant to query an provider.
  In the usual version of an http based api from the provider, you need to do:
  Query the provider server, with the argumens of in the `query()`.
  Then parse the data into `[result()]`.
  If all this worked as expected return {:ok, [result()]}.
  If not return {:error, reason :: term()}.
  """
  @callback search(query()) :: search_result()

  # TODO :)
  @type mod() :: :todo
end
