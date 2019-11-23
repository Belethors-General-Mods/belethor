module MoreFuzzer exposing (..)

import Mod exposing (Mod)
import ModFile exposing (ModFile)
import Tag exposing (Tag)

import Regex
import Fuzz exposing (Fuzzer)
import Url exposing (Url)
import Url.Builder


tag : Fuzzer Tag
tag =
    Fuzz.map (\(id, name) -> Tag id name) <| Fuzz.tuple (Fuzz.int, Fuzz.string)


mod : Fuzzer Mod
mod =
    let fuzz_params = Fuzz.tuple3 ( Fuzz.tuple3 (Fuzz.string, Fuzz.string, Fuzz.bool)
                                  , Fuzz.tuple3 (url, maybe modFile, maybe modFile)
                                  , Fuzz.list tag)
        create = \((name, desc, published), (cf, sse, oldrim), tags) -> Mod name desc published cf sse oldrim tags
    in Fuzz.map create fuzz_params

modFile : Fuzzer ModFile
modFile =
    let create = \((beth, steam, nexus), cc) -> ModFile beth steam nexus cc
    in Fuzz.map create <| Fuzz.tuple (Fuzz.tuple3 (url, url, url), Fuzz.bool)

url : Fuzzer (Maybe Url)
url =
    let fuz_query_params = Fuzz.tuple (Fuzz.string, Fuzz.string) |> Fuzz.map (\(a,b) -> Url.Builder.string a b)
        parse = \(a,b,c) -> Url.Builder.crossOrigin a b c |> Url.fromString
    in Fuzz.map parse <| Fuzz.tuple3 (Fuzz.string, Fuzz.list Fuzz.string, Fuzz.list fuz_query_params)

maybe : Fuzzer a -> Fuzzer (Maybe a)
maybe fuz =
    let capsule = (\boolean val -> if boolean then Just val else Nothing)
    in Fuzz.map2 capsule Fuzz.bool fuz

jsonString : Fuzzer String
jsonString =
    let regex_purge = Maybe.withDefault Regex.never <| Regex.fromString """[\n\t\"\\\\]"""
        replace = Regex.replace regex_purge (\_ -> "")
    in Fuzz.map replace Fuzz.string
