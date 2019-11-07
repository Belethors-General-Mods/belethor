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

view : ModFile -> List (String) -> String -> (Msg -> msg) -> Html msg
view modfile attrs descName cap =
    div []
    [ inputBool ("console_compat" :: attrs) "Compability on Consoles" modfile.console_compat (cap << CC)
    , inputUrl ("bethesda" :: attrs) "Bethesda Url" modfile.beth (cap << Beth)
    , inputUrl ("nexus" :: attrs) "Nexus Url" modfile.nexus (cap << Nexus)
    , inputUrl ("steam" :: attrs) "Steam Url" modfile.steam (cap << Steam)
    ]
