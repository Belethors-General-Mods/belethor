defmodule Crawler.Bethesda.Client do
  @moduledoc "implements `Crawler.Client` for [Nexus Mods](https://www.nexusmods.com/)"
  @behaviour Crawler.Client

  @impl Crawler.Client
  def search(_query) do
    {:error, :not_implemented}
  end
end
