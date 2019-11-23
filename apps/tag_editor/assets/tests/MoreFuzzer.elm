module MoreFuzzer exposing(..)

import ModFile exposing (ModFile)
import Tag exposing (Tag)

import Fuzz
import Url exposing (Url)
import Url.Builder


tag : Fuzzer (Tag)
tag =
    Fuzz.map (\(id, name) -> Tag id name) <| Fuzz.tuple (Fuzz.int, json_string)

modFile : Fuzzer (ModFile)
modFile =
    let create = \((beth, steam, nexus), cc) -> ModFile beth steam nexus url
    in Fuzz.map create <| Fuzz.tuple (Fuzz.tuple3 (url, url, url), Fuzz.bool)

url : Fuzzer (Maybe Url)
url =
    let fuz_query_params = Fuzz.tuple (Fuzz.string, Fuzz.string) |> Fuzz.map (\(a,b) -> Url.Builder.string a b)
        parse = \(a,b,c) -> Url.Builder.crossOrigin a b c |> Url.fromString
    in Fuzz.map parse <| Fuzz.tuple3 (Fuzz.string, Fuzz.list Fuzz.string, Fuzz.list fuz_query_params)

maybe : Fuzzer a -> Fuzzer (Maybe a)
maybe =
    let capsule = (\boolean -> if boolean then Just a else Nothing)
    in Fuzz.map capsule Fuzz.bool

jsonString : Fuzzer String
jsonString =
    let regex_purge = Maybe.withDefault Regex.never <| Regex.fromString """[\n\t\"\\\\]"""
        replace = Regex.replace regex_purge (\_ -> "")
    in Fuzz.map replace Fuzz.string
