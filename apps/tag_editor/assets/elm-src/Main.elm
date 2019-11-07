module Main exposing (..)

import Mod exposing (Mod)
import ModFile exposing (ModFile)
import Utils.Bool
import Utils.Html exposing(..)

import Browser
import Html exposing (Html, div)
import Task
import Json.Decode as JD
import Url

-- MAIN
main =
  Browser.element
      { init = init
      , update = update
      , subscriptions = sub
      , view = view }

-- MODEL
type alias Model = { mod : Mod }

init : JD.Value -> (Model, Cmd Msg)
init flag =
    let mod = case JD.decodeValue Mod.decoder flag of
                Ok result -> result
                Err todo -> Mod.default
    in (Model mod, Cmd.none)

-- UPDATE
type Msg = ChangeMod Mod.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ChangeMod modMsg ->
            ({ model | mod = Mod.update modMsg model.mod }, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
    Mod.view model.mod ["mod"] ChangeMod

sub: Model -> Sub Msg
sub model =
    Sub.none

