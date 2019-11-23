module Utils.Url exposing (..)

import Url exposing (Url)
import Maybe
import Json.Decode as JD
import Json.Encode as JE

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
        Nothing -> ""
        Just url -> Url.toString url

fromString : String -> Maybe Url
fromString val = Url.fromString val
