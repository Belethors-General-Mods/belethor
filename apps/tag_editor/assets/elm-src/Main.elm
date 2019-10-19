module Main exposing (..)

import Mod exposing (Mod)
import ModFile exposing (ModFile)
import Utils.Bool

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Url exposing(Url)

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
  div []
      [ viewInputText "name" "Name" model.mod.name Mod.Name
      , viewInputBool "published" "Published" model.mod.published Mod.Pub
      , viewSubmitButton "btn-success" "Update" ]

viewSubmitButton : String -> String -> Html Msg
viewSubmitButton cl t =
  button [ class ("btn " ++ cl), type_ "submit"] [ text t ]

viewInputText : String -> String -> String -> (String -> Mod.Msg) -> Html Msg
viewInputText atom desc val msg =
  let html = atom2html atom
  in div [ class "form-group" ]
    [ label [ for html.id ] [ text desc ]
    , input [ id html.id, class "form-control", name html.name, type_ "text", value val, onInput (capsuleModChange  msg) ] [] ]

viewInputBool : String -> String -> Bool -> (Bool -> Mod.Msg) -> Html Msg
viewInputBool atom desc val msg =
  let html = atom2html atom
      bt sArg = msg (Utils.Bool.fromString sArg False)
      sVal = Utils.Bool.toString val
  in div [ class "form-group" ]
    [ label [ for html.id ] [ text desc ]
    , input [ id html.id, class "form-control", name html.name, type_ "checkbox", value sVal, onInput (capsuleModChange  bt) ] [] ]

-- viewInputFile : String -> String -> Url -> (Maybe Url -> Mod.Msg) -> Html Msg
-- viewInputFile atom desc val msg =
--  let html = atom2html atom
--      bt sArg = msg (Url.fromString sArg)
--  in div [class "form-group"]
--     [ label [ for html.id ] [ text desc ]
--     , input [ id html.id, class "form-control", name html.name, type_ "checkbox", value val, onInput (capsuleModChange  bt) ] [] ]

atom2html : String -> { id : String, name : String}
atom2html attr = { id = "mod_"++ attr, name = "mod[" ++ attr ++"]" }

capsuleModChange : (String -> Mod.Msg) -> (String -> Msg)
capsuleModChange mm =
  let buildMe sArg = ChangeMod ( mm sArg ) in buildMe

