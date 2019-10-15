module Main exposing (..)

import Mod exposing (Mod)
import ModFile exposing (ModFile)
import Utils.Bool

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

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
  div []
      [ viewInputText "mod_name" "mod[name]" "Name" model.mod.name (capsuleModChange Mod.Name)
      , viewInputBool "mod_published" "mod[published]" "Published" model.mod.published (capsuleModChange Mod.Pub)
      , submitButton "btn-success" "Update" ]

submitButton : String -> String -> Html Msg
submitButton cl t =
  button [ class ("btn " ++ cl), type_ "submit"] [ text t ]

viewInputText : String -> String -> String -> String -> (String -> Msg) -> Html Msg
viewInputText html_id html_name desc val msg =
  div [ class "form-group" ]
    [ label [ for html_id ] [ text desc ]
    , input [ id html_id, class "form-control", type_ "text", value val, onInput msg ] [] ]

viewInputBool : String -> String -> String -> Bool -> (Bool -> Msg) -> Html Msg
viewInputBool html_id html_name desc val msg =
  div [ class "form-group" ]
    [ label [ for html_id ] [ text desc ]
    , input [ id html_id, class "form-control", type_ "checkbox", value val, onInput msg ] [] ]

capsuleModChange : (String -> Mod.Msg) -> (String -> Msg)
capsuleModChange mm =
  let buildMe sArg = ChangeMod ( mm sArg ) in buildMe

