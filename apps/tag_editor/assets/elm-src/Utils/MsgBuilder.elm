module Utils.MsgBuilder exposing (..)


type Change a aMsg
    = Replace a
    | Edit aMsg


type List a
    = Add a
    | Remove a
