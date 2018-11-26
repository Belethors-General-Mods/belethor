defmodule Crawler.Bethesda.Client do
  @behaviour Crawler.Client

  @impl Crawler.Client
  def search(_query) do
    {:error, :not_implemented}
  end
end
