defmodule Crawler.Steam.Client do
  @moduledoc "implements `Crawler.Client` for [Steam](https://steamcommunity.com/app/72850/workshop)"
  @behaviour Crawler.Client

  @impl Crawler.Client
  def search(_query) do
    {:error, :not_implemented}
  end
end
