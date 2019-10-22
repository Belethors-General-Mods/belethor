module Mod exposing (Mod, Msg(..), default, update)

import ModFile exposing(ModFile)
import Utils.Html exposing(..)

import Maybe
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


-- MODEL
type alias Mod =
  { name : String
  , desc : String
  , published : Bool
  , customFile : String
  , sse : Maybe ModFile
  , oldrim : Maybe ModFile
  }

-- UPDATE
type Msg
    = Name String
    | Desc String
    | Pub Bool
    | CFile String
    | SSE ModFile.Msg
    | Oldrim ModFile.Msg

update : Msg -> Mod -> Mod
update msg oldMod =
    case msg of
        Name name -> { oldMod | name = name}
        Desc desc -> { oldMod | desc = desc }
        Pub pub -> { oldMod | published = pub }
        CFile fileUrl -> { oldMod | customFile = fileUrl }
        SSE sseMsg ->
            let newSse = oldMod.sse
                        |> Maybe.withDefault ModFile.default
                        |> ModFile.update sseMsg
                        |> Just
            in { oldMod | sse = newSse }
        Oldrim oldrimMsg ->
            let newOldrim = oldMod.oldrim
                           |> Maybe.withDefault ModFile.default
                           |> ModFile.update oldrimMsg
                           |> Just
            in { oldMod | oldrim = newOldrim }

default : Mod
default =
    Mod "" "" False "" Nothing Nothing

viewForm : Mod -> String -> ((b -> otherMsg) -> List (Html otherMsg))
viewForm mod varName =
    let a cap = [ inputText (varName ++ "_name") (varName ++ "[name]") "Name" mod.name (cap Name)
                , inputBool (varName ++ "_published") (varName ++ "[published]") "Published" mod.published (cap Pub)
                , textArea (varName ++ "_desc") (varName ++ "[desc]") "Description" mod.desc (cap Desc)
                , submit "btn-success" "Update" ]
    in a

