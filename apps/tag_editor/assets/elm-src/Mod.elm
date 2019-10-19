module Mod exposing (Mod, Msg(..), default, update)

import ModFile exposing(ModFile)
import Maybe
import Url exposing(Url)

-- MODEL
type alias Mod =
  { name : String
  , desc : String
  , published : Bool
  , customFile : Maybe Url
  , sse : Maybe ModFile
  , oldrim : Maybe ModFile
  }

-- UPDATE
type Msg
    = Name String
    | Desc String
    | Pub Bool
    | CFile (Maybe Url)
    | SSE ModFile.Msg
    | Oldrim ModFile.Msg

update : Msg -> Mod -> Mod
update msg old_mod =
    case msg of
        Name name -> { old_mod | name = name}
        Desc desc -> { old_mod | desc = desc }
        Pub pub -> { old_mod | published = pub }
        CFile fileUrl -> { old_mod | customFile = fileUrl }
        SSE sseMsg ->
            let new_sse = old_mod.sse
                        |> Maybe.withDefault ModFile.default
                        |> ModFile.update sseMsg
                        |> Just
            in { old_mod | sse = new_sse }
        Oldrim oldrimMsg ->
            let new_oldrim = old_mod.oldrim
                           |> Maybe.withDefault ModFile.default
                           |> ModFile.update oldrimMsg
                           |> Just
            in { old_mod | oldrim = new_oldrim }

default : Mod
default =
    Mod "" "" False Nothing Nothing Nothing
