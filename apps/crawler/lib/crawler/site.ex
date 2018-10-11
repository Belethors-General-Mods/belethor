defmodule Crawler.Site do
  @moduledoc """
  Defines a common API for all crawlers.
  """

  @typedoc """
  An atom representing one of the games supported by our crawlers

  Currently, only Skyrim and Skyrim Special Edition are
  supported; more might be added later
  """
  @type supported_game :: :skyrim | :skyrim_se

  @typedoc """
  A cheap-to-construct intermediate tuple containing info about a given mod
  """
  @type mod_info :: {
          source :: atom(),
          game :: supported_game(),
          name :: String.t(),
          tags :: [String.t()],
          uri :: URI.t(),
          image_urls :: [String.t()]
        }

  @doc """
  Return an atom identifying the crawler
  """
  @callback id() :: atom()

  @doc """
  Get a site-specific representation of a game
  """
  @callback game_id(game :: supported_game()) :: term()

  @doc """
  Given a mod's name, get a URI that points to an information source about that mod
  """
  @callback mod_uri(mod_name :: String.t()) :: URI.t()

  @doc """
  Given a full HTML page, extract as much information about a mod as possible
  """
  @callback extract_info(html :: Floki.html_tree()) :: mod_info

  @doc """
  Convert mod info to a format the databse understands so it can be saved
  """
  @callback make_persistable(info :: mod_info) :: Database.Schema.Mod
end
