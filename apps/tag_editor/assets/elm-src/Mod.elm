module Mod exposing (Mod, Msg(..), default, update, view, decoder, tag2option )

import ModFile exposing(ModFile)
import Tag exposing(Tag)

import Utils.Html exposing(..)
import Utils.List
import Utils.MsgBuilder as MB
import Utils.Json
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
        (Utils.Json.field "name" JD.string default.name)
        (Utils.Json.field "desc" JD.string default.desc)
        (Utils.Json.field "published" JD.bool default.published)
        (Utils.Json.field "image" Utils.Url.decoder default.customFile )
        (Utils.Json.field "sse" (JD.maybe ModFile.decoder) default.sse)
        (Utils.Json.field "oldrim" (JD.maybe ModFile.decoder) default.oldrim)
        (Utils.Json.field "tags" (JD.list Tag.decoder) default.tags)

view : Mod -> List (String) -> (Msg -> msg) -> Html msg
view mod attrs cap =
    div []
        [ inputText ("name" :: attrs) "Name" mod.name (cap << Name)
        , inputBool ("published" :: attrs) ("Published", "yes", "no") mod.published (cap << Pub)
        , viewTags ("tags" :: attrs) mod.tags (cap << Tags)
        , textArea ("desc" :: attrs) "Description" mod.desc (cap << Desc)
        , viewModFile ("sse" :: attrs) "Skyrim Special Edition" mod.sse (cap << SSE)
        , viewModFile ("oldrim" :: attrs) "Oldrim" mod.oldrim (cap << Oldrim)
        , submit "btn-success" "Update" ]

viewModFile : List (String) -> String -> Maybe ModFile -> (MB.Change (Maybe ModFile) ModFile.Msg -> msgt) -> Html msgt
viewModFile attrs name mm cap =
    case mm of
        Just modfile ->
            div [ class "modfilebox" ]
                [ Html.h4 [] [ Html.text name ]
                , bbutton "Delete" ((cap << MB.Replace) Nothing)
                , ModFile.view modfile attrs name (cap << MB.Edit) ]
        Nothing -> viewCreateModFile name (Just ModFile.default) (cap << MB.Replace)

viewCreateModFile : String -> Maybe ModFile -> (Maybe ModFile -> msgt) -> Html msgt
viewCreateModFile name defaultVal cap =
    div [] [ bbutton ("add a " ++ name ++ " modfile") (cap <| Just ModFile.default) ]

viewTags : List(String) -> List (Tag) -> ((MB.Change (List Tag) (MB.List Tag)) -> msgt) -> Html msgt
viewTags path tags msg =
    optionMultiSelect path "Tags" (List.map (tag2option ("" :: path) (msg << MB.Edit << MB.Remove)) tags)

tag2option : List (String) -> (Tag -> msgt) -> Tag -> Option msgt
tag2option path msg tag =
    Option (String.fromInt tag.id) True tag.name "green" path (msg tag)
