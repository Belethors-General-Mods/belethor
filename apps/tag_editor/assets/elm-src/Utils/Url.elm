module Utils.Url exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Maybe
import Url exposing (Url)


decoder : JD.Decoder (Maybe Url)
decoder =
    JD.oneOf
        [ JD.null Nothing
        , JD.map fromString JD.string
        ]


encode : Maybe Url -> JE.Value
encode url =
    JE.string <| toString url


toString : Maybe Url -> String
toString val =
    case val of
        Nothing ->
            ""

        Just url ->
            Url.toString url


fromString : String -> Maybe Url
fromString val =
    Url.fromString val
