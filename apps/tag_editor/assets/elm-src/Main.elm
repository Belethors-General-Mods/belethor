module Main exposing (..)

import Mod exposing (Mod)
import ModFile exposing (ModFile)
import Utils.Bool
import Utils.Html

import Browser

-- MAIN
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model = { mod : Mod }

init : Model
init = -- TODO check out how to reload this whole bitch at once
  let sse    = ModFile "beth" "nexus" "steam" False |> Just
      oldrim = ModFile "beth" "nexus" "steam" True |> Just
      mod = Mod "name" "desc" True "file_url" sse oldrim
  in  Model mod

-- UPDATE
type Msg = ChangeMod Mod.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    ChangeMod modMsg ->
        let new_mod = Mod.update modMsg model.mod
        in { model | mod = new_mod }

-- VIEW
view : Model -> Html Msg
view model =
  div [] (Mod.viewForm model.mod "mod" capsulateModChange)

capsuleModChange : (a -> Mod.Msg) -> (a -> Msg)
capsuleModChange mm =
  let buildMe sArg = ChangeMod ( mm sArg ) in buildMe

