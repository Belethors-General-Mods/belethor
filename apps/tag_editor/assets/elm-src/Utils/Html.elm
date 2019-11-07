module Utils.Html exposing (submit, textArea, bbutton, inputText, inputUrl, inputBool)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput,onClick)
import Url exposing (Url)

import Utils.Bool
import Utils.Url

submit : String -> String -> Html msg
submit cl t =
  button [ class ("btn " ++ cl), type_ "submit"] [ text t ]

textArea : List(String) -> String -> String -> (String -> msg) -> Html msg
textArea path desc val msg =
  let htmlId = buildId path
      htmlName = buildName path
  in div [ class "form-group" ]
    [ label [ for htmlId ] [ text desc ]
    , textarea [ id htmlId, class "form-control", rows 10, name htmlName, value val, onInput msg ] [] ]

bbutton : String -> msg -> Html msg
bbutton desc click =
    button [ type_ "button", class "btn btn-primary", onClick click ] [ text desc ]


inputText : List(String) -> String -> String -> (String -> msg) -> Html msg
inputText path desc val msg =
  let htmlId = buildId path
      htmlName = buildName path
  in div [ class "form-group" ]
      [ label [ for htmlId ] [ text desc ]
      , input [ id htmlId, class "form-control", type_ "text", name htmlName, value val, onInput msg ] [] ]



-- this is still has a lot more potential than just one text input
inputUrl : List(String) -> String -> Maybe Url -> (Maybe Url -> msg) -> Html msg
inputUrl path desc val msg =
    inputText path desc (Utils.Url.toString val) (msg << Utils.Url.fromString)


inputBool : List(String) -> String -> Bool -> (Bool -> msg) -> Html msg
inputBool path desc val msg =
  let htmlId = buildId path
      htmlName = buildName path
      inputHandler sArg = msg (not val)
--    sVal = Utils.Bool.toString val
  in div [ class "form-group" ]
      [ div [ class "custom-control custom-switch" ]
            [ input [ id htmlId, class "custom-control-input", type_ "checkbox"
                    , name htmlName, checked val, onInput inputHandler ] []
           , label [ for htmlId, class "custom-control-label"] [ text desc ]
           ]
      ]

buildId : List(String) -> String
buildId path =
    List.reverse path |> String.join "_"

buildName : List(String) -> String
buildName path =
    let r = List.reverse path
        h = case List.head r of
                Just l -> l
                Nothing -> ""
        a s = "[" ++ s ++ "]"
        t = case List.tail r of
                Just indexie -> List.map a indexie
                Nothing -> List.take 0 [""]
    in String.join "" (h :: t)
