defmodule Crawler.Nexus do
  require Logger

  def import_mods(amount) do
  end

  defp import_page(page, rim) do
    fetch_page(page, rim)
    |> Floki.find("li.mod-tile > .mod-tile-left")
    |> Enum.map(&import_tile/1)
  end

  defp import_tile(tile) do
    try do
      %Database.NexusMod{ parse_tile(tile) | rim: rim }
    rescue
      MatchError ->
        Logger.warn("parsing of a nexus mod tile failed")
    else
      #TODO: check wether nexus_mod.url is already stored
      %Database.NexusMod{} = mod  -> Database.Repo.insert!(mod)
    end
  end

  defp fetch_page(page, rim) do
    baseurl = "https://www.nexusmods.com/Core/Libs/Common/Widgets/ModList"
    url = "#{baseurl}?RH_ModList=nav:true,home:false,type:0,user_id:0,game_id:#{rim},advfilt:true,include_adult:false,sort_by:OLD_endorsements,order:DESC,show_game_filter:false,page_size:20,page:#{page}"
    %HTTPoison.Response{ status_code: 200, body: html } = HTTPoison.get!(url)
    html
  end

  defp parse_tile(tile) do
    desc = Floki.find(tile, "p.desc") |> Floki.text()
    [pic] = Floki.find(tile, "a.mod-image img.fore") |> Floki.attribute("src")
    head = Floki.find(tile, ".tile-content > h3 > a")
    name = Floki.text(head)
    [link] = Floki.attribute(head, "href")
    %Database.NexusMod{name: name, desc: desc, pic: pic, url: link}
  end

end
