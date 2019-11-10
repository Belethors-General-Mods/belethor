module Mod exposing (Mod, Msg(..), default, update, view, decoder)

import ModFile exposing(ModFile)
import Tag exposing(Tag)

import Utils.Html exposing(..)
import Utils.List
import Utils.MsgBuilder as MB
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
  , tags : List (Tag)
  }

-- UPDATE
type Msg
    = Name String
    | Desc String
    | Pub Bool
    | CFile (Maybe Url)
    | SSE (MB.Change (Maybe ModFile) ModFile.Msg)
    | Oldrim (MB.Change (Maybe ModFile) ModFile.Msg)
    | Tags (MB.Change (List Tag) (MB.List Tag))

update : Msg -> Mod -> Mod
update msg oldMod =
    case msg of
        Name name -> { oldMod | name = name}
        Desc desc -> { oldMod | desc = desc }
        Pub pub -> { oldMod | published = pub }
        CFile fileUrl -> { oldMod | customFile = fileUrl }
        SSE sseMsg -> { oldMod | sse = (updateModFile oldMod.sse sseMsg) }
        Oldrim oldrimMsg -> { oldMod | oldrim = (updateModFile oldMod.oldrim oldrimMsg) }
        Tags tagsMsg -> { oldMod | tags = (updateTagList oldMod.tags tagsMsg)}

updateModFile : Maybe ModFile -> MB.Change (Maybe ModFile) ModFile.Msg -> Maybe ModFile
updateModFile mm updateMsg =
    case updateMsg of
        MB.Replace newModfile -> newModfile
        MB.Edit mfMsg ->
            let modfile = case mm of
                              Nothing -> ModFile.default
                              Just mf -> mf
             in Just (ModFile.update mfMsg modfile)

updateTagList : List(Tag) -> MB.Change (List Tag) (MB.List Tag) -> List(Tag)
updateTagList tags updateMsg =
    case updateMsg of
        MB.Replace newList -> newList
        MB.Edit (MB.Add newItem) -> newItem :: tags
        MB.Edit (MB.Remove removeMe) -> Utils.List.remove removeMe tags

default : Mod
default =
    Mod "" "" False Nothing Nothing Nothing []

decoder : JD.Decoder Mod
decoder =
    JD.map7 Mod
        (JD.field "name" JD.string)
        (JD.field "desc" JD.string)
        (JD.field "published" JD.bool)
        (JD.field "image" Utils.Url.decoder)
        (JD.field "sse" (JD.maybe ModFile.decoder))
        (JD.field "oldrim" (JD.maybe ModFile.decoder))
        (JD.field "tags" (JD.list Tag.decoder))

view : Mod -> List (String) -> (Msg -> msg) -> Html msg
view mod attrs cap =
    div []
        [ inputText ("name" :: attrs) "Name" mod.name (cap << Name)
        , inputBool ("published" :: attrs) ("Published", "yes", "no") mod.published (cap << Pub)
        , textArea ("desc" :: attrs) "Description" mod.desc (cap << Desc)
--TODO  , optionMultiSelect
        , viewModFile ("sse" :: attrs) "Skyrim Special Edition" mod.sse (cap << SSE)
        , viewModFile ("oldrim" :: attrs) "Oldrim" mod.oldrim (cap << Oldrim)
        , submit "btn-success" "Update" ]

viewModFile : List (String) -> String -> Maybe ModFile -> (MB.Change (Maybe ModFile) ModFile.Msg -> msg) -> Html msg
viewModFile attrs name mm  cap =
    case mm of
        Just modfile ->
            div [ class "modfilebox" ]
                [ Html.h4 [] [ Html.text name ]
                , bbutton "Delete" ((cap << MB.Replace) Nothing)
                , ModFile.view modfile attrs name (cap << MB.Edit) ]
        Nothing -> viewCreateModFile name (Just ModFile.default) (cap << MB.Replace)

viewCreateModFile : String -> Maybe ModFile -> (Maybe ModFile -> msg) -> Html msg
viewCreateModFile name defaultVal cap =
    div [] [ bbutton ("add a " ++ name ++ " modfile") (cap <| Just ModFile.default) ]
