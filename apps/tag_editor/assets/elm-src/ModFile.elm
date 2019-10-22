module ModFile exposing (ModFile, Msg(..), default, update)

import Maybe
import Url exposing (Url)

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

update : Msg -> ModFile -> ModFile
update msg old_mod =
    case msg of
        Beth b -> { old_mod | beth = b }
        Nexus n -> { old_mod | nexus = n }
        Steam s -> { old_mod | steam = s }
        CC cc  -> { old_mod | console_compat = cc }
