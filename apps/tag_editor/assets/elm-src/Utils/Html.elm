module Utils.Html exposing
    ( Option
    , bbutton
    , inputBool
    , inputText
    , inputUrl
    , optionMultiSelect
    , optionSelect
    , submit
    , textArea
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Url exposing (Url)
import Utils.Bool
import Utils.Url


type alias Option msgt =
    { value : String
    , enabled : Bool
    , text : String
    , colorCode : String
    , path : List String
    , msg : msgt
    }


{-| return a bootstrap submit button
-}
submit : String -> String -> Html msg
submit cl t =
    button [ class ("btn " ++ cl), type_ "submit" ] [ text t ]


{-| return a bootstrap button
-}
bbutton : String -> msg -> Html msg
bbutton desc click =
    button [ type_ "button", class "btn btn-primary", onClick click ] [ text desc ]


{-| return a bootstrap textarea
-}
textArea : List String -> String -> String -> (String -> msg) -> Html msg
textArea path desc val msg =
    let
        htmlId =
            buildId path

        htmlName =
            buildName path
    in
    div [ class "form-group" ]
        [ label [ for htmlId ] [ text desc ]
        , textarea [ id htmlId, class "form-control", rows 10, name htmlName, value val, onInput msg ] []
        ]


{-| input field for text
-}
inputText : List String -> String -> String -> (String -> msg) -> Html msg
inputText path desc val msg =
    let
        htmlId =
            buildId path

        htmlName =
            buildName path
    in
    div [ class "form-group" ]
        [ label [ for htmlId ] [ text desc ]
        , input [ id htmlId, class "form-control", type_ "text", name htmlName, value val, onInput msg ] []
        ]


{-| input field for an url, this is still has a lot more potential than just one text input
-}
inputUrl : List String -> String -> Maybe Url -> (Maybe Url -> msg) -> Html msg
inputUrl path desc val msg =
    inputText path desc (Utils.Url.toString val) (msg << Utils.Url.fromString)



-- see for styling https://codepen.io/CameronFitzwilliam/pen/RxYbgg
-- or https://codepen.io/adamstuartclark/pen/pbYVYR/


{-| input field for a boolean value
-}
inputBool : List String -> ( String, String, String ) -> Bool -> (Bool -> msg) -> Html msg
inputBool path ( desc, trueText, falseText ) val msg =
    optionSelect path
        desc
        [ Option "true" val trueText "blue" ("true" :: path) (msg True)
        , Option "false" (not val) falseText "red" ("false" :: path) (msg False)
        ]


{-| input field for a predefined amount of options
-}
optionSelect : List String -> String -> List (Option msg) -> Html msg
optionSelect path desc options =
    let
        htmlId =
            buildId path
    in
    div [ id htmlId, class "custom-control custom-rad" ]
        ([ p [ class "option-toplabel" ] [ text desc ] ] ++ List.map optionViewRadio options)


optionMultiSelect : List String -> String -> List (Option msg) -> Html msg
optionMultiSelect path desc options =
    let
        htmlId =
            buildId path
    in
    div [ id htmlId ] ([ h5 [] [ text desc ] ] ++ List.map optionViewButton options)



-- private utils


optionViewButton : Option msg -> Html msg
optionViewButton opt =
    let
        htmlId =
            buildId opt.path

        htmlName =
            buildName ("id" :: opt.path)
    in
    span [ class "multi_option" ]
        [ input [ id htmlId, name htmlName, type_ "hidden", onClick opt.msg, value opt.value ] []
        , label [ for htmlId ] [ text opt.text ]
        , input [ type_ "button", class "btn btn-danger btn-sm  remove", onClick opt.msg, value "x" ] []
        ]


optionViewRadio : Option msg -> Html msg
optionViewRadio opt =
    let
        htmlId =
            buildId opt.path

        htmlName =
            buildNameBase opt.path
    in
    div [ class "custom-control-inline" ]
        [ input [ id htmlId, type_ "radio", name htmlName, checked opt.enabled, value opt.value ] []
        , label [ for htmlId ] [ text opt.text ]
        ]


buildId : List String -> String
buildId path =
    List.reverse path |> String.join "_"


buildName : List String -> String
buildName path =
    let
        r =
            List.reverse path

        h =
            case List.head r of
                Just l ->
                    l

                Nothing ->
                    ""

        a s =
            "[" ++ s ++ "]"

        t =
            case List.tail r of
                Just indexie ->
                    List.map a indexie

                Nothing ->
                    emptyStringList
    in
    String.join "" (h :: t)


buildNameBase : List String -> String
buildNameBase path =
    case List.tail path of
        Nothing ->
            buildName emptyStringList

        Just t ->
            buildName t


emptyStringList : List String
emptyStringList =
    List.take 0 [ "" ]
