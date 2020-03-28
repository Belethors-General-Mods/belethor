module Main exposing (..)

import Browser
import Html exposing (Html, div)
import Json.Decode as JD
import Mod exposing (Mod)
import Tag exposing (Tag)
import Task
import Url
import Utils.Bool
import Utils.Html exposing (..)
import Utils.MsgBuilder as MB



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = sub
        , view = view
        }



-- MODEL


type alias Model =
    { mod : Mod
    , tags : List Tag
    }


init : JD.Value -> ( Result String Model, Cmd Msg )
init flag =
    let
        state =
            case JD.decodeValue decoder flag of
                Ok model ->
                    Ok model

                Err err ->
                    Err (JD.errorToString err)
    in
    ( state, Cmd.none )



-- UPDATE


type Msg
    = ChangeMod Mod.Msg


update : Msg -> Result String Model -> ( Result String Model, Cmd Msg )
update msg state =
    case state of
        Ok model ->
            case msg of
                ChangeMod modMsg ->
                    ( Ok { model | mod = Mod.update modMsg model.mod }, Cmd.none )

        Err err ->
            ( Err err, Cmd.none )



-- VIEW


view : Result String Model -> Html Msg
view state =
    case state of
        Ok model ->
            div []
                [ Mod.view model.mod [ "mod" ] ChangeMod
                , viewTags model.tags
                ]

        Err errs ->
            Html.text errs


sub : Result String Model -> Sub Msg
sub state =
    Sub.none


decoder : JD.Decoder Model
decoder =
    JD.map2 Model
        (JD.field "mod" Mod.decoder)
        (JD.field "tags" (JD.list Tag.decoder))


viewTags : List Tag -> Html Msg
viewTags tags =
    optionMultiSelect [] "Tags to select: (click on the red x to add a tag)" (List.map (Mod.tag2option [] (ChangeMod << Mod.Tags << MB.Edit << MB.Add)) tags)
