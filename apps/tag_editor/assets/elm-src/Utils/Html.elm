module Utils.Html exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput,onClick)
import Url exposing (Url)

import Utils.Bool
import Utils.Url

submit : String -> String -> Html msg
submit cl t =
  button [ class ("btn " ++ cl), type_ "submit"] [ text t ]

textArea : String -> String -> String -> String -> (String -> msg) -> Html msg
textArea htmlId htmlName desc val msg =
  div [ class "form-group" ]
    [ label [ for htmlId ] [ text desc ]
    , textarea [ id htmlId, name htmlName, value val, onInput msg ] [] ]


bbutton : String -> msg -> Html msg
bbutton desc click =
    button [ type_ "button", class "btn btn-primary", onClick click ] [ text desc ]


inputText : String -> String -> String -> String -> (String -> msg) -> Html msg
inputText htmlId htmlName desc val msg =
  div [ class "form-group" ]
    [ label [ for htmlId ] [ text desc ]
    , input [ id htmlId, class "form-control", type_ "text", name htmlName, value val, onInput msg ] [] ]



-- this is still has a lot more potential than just one text input
inputUrl : String -> String -> String -> Maybe Url -> (Maybe Url -> msg) -> Html msg
inputUrl htmlId htmlName desc val msg =
    inputText htmlId htmlName desc (Utils.Url.toString val) (msg << Utils.Url.fromString)


inputBool : String -> String -> String -> Bool -> (Bool -> msg) -> Html msg
inputBool htmlId htmlName desc val msg =
  let inputHandler sArg = msg (Utils.Bool.fromString sArg False)
      sVal = Utils.Bool.toString val
  in div [ class "form-group" ]
      [ label [ for htmlId ] [ text desc ]
      , input [ id htmlId, class "form-control", type_ "checkbox", name htmlName, value sVal, onInput inputHandler ] [] ]
