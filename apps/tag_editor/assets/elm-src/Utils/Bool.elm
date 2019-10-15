module Utils.Bool exposing(..)

toString : Bool -> String
toString b =
  case b of
    True -> "true"
    False -> "false"

fromString : String -> Bool -> Bool
fromString s default =
  case s of
    "true" -> True
    "false" -> False
    _ -> default
