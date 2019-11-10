module Mod exposing (Mod, Msg(..), default, update, view, decoder)

import ModFile exposing(ModFile)
import Utils.Html exposing(..)
import Utils.Url

import Maybe
import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Json.Decode as JD
import Url exposing(Url)


-- MODEL
type alias Mod =
  { name : String
  , desc : String
  , published : Bool
  , customFile : Maybe Url
  , sse : Maybe ModFile
  , oldrim : Maybe ModFile
  }

-- UPDATE

type ModFileUpdate = New (Maybe ModFile.ModFile) | Update ModFile.Msg

type Msg
    = Name String
    | Desc String
    | Pub Bool
    | CFile (Maybe Url)
    | SSE ModFileUpdate
    | Oldrim ModFileUpdate

update : Msg -> Mod -> Mod
update msg oldMod =
    case msg of
        Name name -> { oldMod | name = name}
        Desc desc -> { oldMod | desc = desc }
        Pub pub -> { oldMod | published = pub }
        CFile fileUrl -> { oldMod | customFile = fileUrl }
        SSE sseMsg -> { oldMod | sse = (updateModFile oldMod.sse sseMsg) }
        Oldrim oldrimMsg -> { oldMod | oldrim = (updateModFile oldMod.oldrim oldrimMsg) }

updateModFile : Maybe ModFile -> ModFileUpdate -> Maybe ModFile
updateModFile mm updateMsg =
    case updateMsg of
        New newModfile -> newModfile
        Update mfMsg ->
            let modfile = case mm of
                              Nothing -> ModFile.default
                              Just mf -> mf
             in Just (ModFile.update mfMsg modfile)

default : Mod
default =
    Mod "" "" False Nothing Nothing Nothing

decoder : JD.Decoder Mod
decoder =
    JD.map6 Mod
        (JD.field "name" JD.string)
        (JD.field "desc" JD.string)
        (JD.field "published" JD.bool)
        (JD.field "image" Utils.Url.decoder)
        (JD.field "sse" (JD.maybe ModFile.decoder))
        (JD.field "oldrim" (JD.maybe ModFile.decoder))

view : Mod -> List (String) -> (Msg -> msg) -> Html msg
view mod attrs cap =
    div []
        [ inputText ("name" :: attrs) "Name" mod.name (cap << Name)
        , inputBool ("published" :: attrs) ("Published", "yes", "no") mod.published (cap << Pub)
        , textArea ("desc" :: attrs) "Description" mod.desc (cap << Desc)
        , viewModFile ("sse" :: attrs) "Skyrim Special Edition" mod.sse (cap << SSE)
        , viewModFile ("oldrim" :: attrs) "Skyrim Legendary Edition" mod.oldrim (cap << Oldrim)
        , submit "btn-success" "Update" ]

viewModFile : List (String) -> String -> Maybe ModFile -> (ModFileUpdate -> msg) -> Html msg
viewModFile attrs name mm  cap =
    case mm of
        Just modfile ->
            div [ class "modfilebox" ]
                [ Html.h4 [] [ Html.text name ]
                , bbutton "Delete" ((cap << New) Nothing)
                , ModFile.view modfile attrs name (cap << Update) ]
        Nothing -> viewCreateModFile name (Just ModFile.default) (cap << New)

viewCreateModFile : String -> Maybe ModFile -> (Maybe ModFile -> msg) -> Html msg
viewCreateModFile name defaultVal cap =
    div [] [ bbutton ("add a " ++ name ++ " modfile") (cap <| Just ModFile.default) ]
