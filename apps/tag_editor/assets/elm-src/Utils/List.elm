module Utils.List exposing (..)


remove : a -> List a -> List a
remove removeMe =
    List.filter (\i -> i /= removeMe)
