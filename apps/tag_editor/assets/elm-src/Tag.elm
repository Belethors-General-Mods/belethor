module Tag exposing (Tag, view, decoder)

import Json.Decode as JD
import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

type alias Tag = { id : Int, name : String }

-- no need for a update function, a tag should not change

decoder : JD.Decoder Tag
decoder =
    JD.map2 Tag
        (JD.field "id" JD.int)
        (JD.field "name" JD.string)

view : Tag -> List (String) -> msg -> Html msg
view tag attrs cap =
    div [ class "tag-view" ] [ text tag.name ]

