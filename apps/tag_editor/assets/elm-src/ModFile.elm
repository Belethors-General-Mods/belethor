module ModFile exposing (ModFile, Msg(..), default, update, view, decoder)

import Maybe
import Url exposing (Url)
import Json.Decode as JD

import Html exposing (Html, div)
import Utils.Html exposing (..)
import Utils.Url


type alias ModFile =
  { beth : Maybe Url
  , nexus : Maybe Url
  , steam : Maybe Url
  , console_compat : Bool
  }

type Msg
    = Beth (Maybe Url)
    | Nexus (Maybe Url)
    | Steam (Maybe Url)
    | CC Bool

default : ModFile
default = ModFile Nothing Nothing Nothing False

decoder : JD.Decoder ModFile
decoder =
    JD.map4 ModFile
        (JD.field "bethesda" Utils.Url.decoder)
        (JD.field "nexus" Utils.Url.decoder)
        (JD.field "steam" Utils.Url.decoder)
        (JD.field "console_compat" JD.bool)

update : Msg -> ModFile -> ModFile
update msg old_mod =
    case msg of
        Beth b -> { old_mod | beth = b }
        Nexus n -> { old_mod | nexus = n }
        Steam s -> { old_mod | steam = s }
        CC cc  -> { old_mod | console_compat = cc }

view : ModFile -> String -> String -> (Msg -> msg) -> Html msg
view modfile varName descName cap =
    div []
    [ let name = varName ++ "_bethesda"
          for  = varName ++ "[bethesda]"
      in inputUrl name for "Bethesda Url" modfile.beth (cap << Beth)

    , let name = varName ++ "_nexus"
          for  = varName ++ "[nexus]"
      in inputUrl name for "Nexus Url" modfile.nexus (cap << Nexus)

    , let name = varName ++ "_steam"
          for  = varName ++ "[steam]"
      in inputUrl name for "Steam Url" modfile.steam (cap << Steam)
    ]
