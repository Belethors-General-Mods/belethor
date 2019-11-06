module Utils.Url exposing (..)

import Url exposing (..)
import Maybe
import Json.Decode as JD

decoder : JD.Decoder (Maybe Url)
decoder =
    JD.oneOf
        [ JD.null Nothing
        , JD.map fromString JD.string
        ]

toString : Maybe Url -> String
toString val =
    case val of
        Nothing -> ""
        Just url -> Url.toString url

fromString : String -> Maybe Url
fromString val = Url.fromString val
