defmodule EchoProvider do
  @behaviour Crawler.SearchProvider
  def search(query) do
    query
  end
end

defmodule BlockingProvider do
  @behaviour Crawler.SearchProvider
  def search(query) do
    :timer.sleep(:infinity)
    query
  end
end

ExUnit.start()
