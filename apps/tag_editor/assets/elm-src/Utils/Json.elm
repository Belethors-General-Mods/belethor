module Utils.Json exposing (..)

import Json.Decode as JD

field : String -> JD.Decoder t -> t -> JD.Decoder t
field name decoder default =
    JD.field name (JD.oneOf [ decoder, JD.null default ])
