module Utils.Html exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


import Utils.Bool

submit : String -> String -> Html msg
submit cl t =
  button [ class ("btn " ++ cl), type_ "submit"] [ text t ]

textArea : String -> String -> String -> String -> (String -> msg) -> Html msg
textArea htmlId htmlName desc val msg =
  div [ class "form-group" ]
    [ label [ for htmlId ] [ text desc ]
    , textarea [ id htmlId, name htmlName, value val, onInput msg ] [] ]

inputText : String -> String -> String -> String -> (String -> msg) -> Html msg
inputText htmlId htmlName desc val msg =
  div [ class "form-group" ]
    [ label [ for htmlId ] [ text desc ]
    , input [ id htmlId, class "form-control", type_ "text", name htmlName, value val, onInput msg ] [] ]

inputBool : String -> String -> String -> Bool -> (Bool -> msg) -> Html msg
inputBool htmlId htmlName desc val msg =
  let inputHandler sArg = msg (Utils.Bool.fromString sArg False)
      sVal = Utils.Bool.toString val
  in div [ class "form-group" ]
    [ label [ for htmlId ] [ text desc ]
    , input [ id htmlId, class "form-control", type_ "checkbox", name htmlName, value sVal, onInput inputHandler ] [] ]
