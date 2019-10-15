module ModFile exposing (ModFile, Msg(..), default, update)

type alias ModFile =
  { beth : String
  , nexus : String
  , steam : String
  , console_compat : Bool
  }

type Msg
    = Beth String
    | Nexus String
    | Steam String
    | CC Bool

default : ModFile
default =
    ModFile "" "" "" False

update : Msg -> ModFile -> ModFile
update msg old_mod =
    case msg of
        Beth b -> { old_mod | beth = b }
        Nexus n -> { old_mod | nexus = n }
        Steam s -> { old_mod | steam = s }
        CC cc  -> { old_mod | console_compat = cc }
