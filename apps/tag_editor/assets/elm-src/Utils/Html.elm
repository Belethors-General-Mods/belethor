module Utils.Html exposing (submit, textArea, bbutton, inputText, inputUrl, inputBool)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput,onClick)
import Url exposing (Url)

import Utils.Bool
import Utils.Url

type alias Option msgt = { value : String
                         , enabled : Bool
                         , text : String
                         , colorCode : String
                         , path : List (String)
                         , msg : msgt }

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

optionSelect : List(String) -> String -> List(Option msg) -> Html msg
optionSelect path desc options =
  let htmlId = buildId path
  in div [ id htmlId, class "custom-control custom-rad"]
      ([ p [ class "option-toplabel" ] [ text desc ] ] ++ (List.map optionView options))

optionView : Option msg -> Html msg
optionView opt =
    let htmlId = buildId opt.path
        htmlName = buildNameBase opt.path
    in div [ class "custom-control-inline" ]
        [ input [ id htmlId, type_ "radio", name htmlName, checked opt.enabled, value opt.value ] []
        , label [ for htmlId ] [ text opt.text ] ]


-- this is still has a lot more potential than just one text input
inputUrl : List(String) -> String -> Maybe Url -> (Maybe Url -> msg) -> Html msg
inputUrl path desc val msg =
    inputText path desc (Utils.Url.toString val) (msg << Utils.Url.fromString)


inputBool : List(String) -> (String, String, String) -> Bool -> (Bool -> msg) -> Html msg
inputBool path (desc, trueText, falseText) val msg =
    optionSelect path desc
        [ Option "true" (val) trueText "blue" ("true" :: path) (msg True)
        , Option "false" (not val) falseText "red" ("false" :: path) (msg False)
        ]

-- private utils
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
                Nothing -> emptyStringList
    in String.join "" (h :: t)

buildNameBase : List(String) -> String
buildNameBase path =
    case List.tail path of
        Nothing -> buildName emptyStringList
        Just t -> buildName t

emptyStringList : List(String)
emptyStringList = List.take 0 [""]
