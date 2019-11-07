module Utils.Bool exposing(..)

toString : Bool -> String
toString b =
  case b of
    True -> "true"
    False -> "false"

fromString : String -> Bool -> Bool
fromString s default =
    let z = Debug.log "convert boolean" s
    in case s of
           "true" -> True
           "on" -> True
           "false" -> False
           "off" -> False
           _ -> default
