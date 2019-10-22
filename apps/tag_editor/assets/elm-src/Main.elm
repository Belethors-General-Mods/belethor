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
init = Model Mod.default -- TODO check out how to load this whole bitch at once

-- UPDATE
type Msg = ChangeMod Mod.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    ChangeMod modMsg ->
      { model | mod = Mod.update modMsg model.mod }

-- VIEW
view : Model -> Html Msg
view model =
  div [] (Mod.viewForm model.mod "mod" capsulateModChange)

capsuleModChange : (a -> Mod.Msg) -> (a -> Msg)
capsuleModChange mm =
  let buildMe sArg = ChangeMod ( mm sArg ) in buildMe

