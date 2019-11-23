module DecoderTest exposing (..)

import ModFile exposing (ModFile)
import Tag exposing (Tag)


import Regex
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Test exposing (Test)
import Json.Decode as JD
import Url exposing (Url)
import Url.Builder
import Utils.Bool
import Utils.Url

suite : Test
suite =
    Test.describe "test / fuzz the json decoder functions"
        [ Test.fuzz (Fuzz.tuple (Fuzz.int, json_string)) "fuzz the Tag decoder" <|
              \(tag) ->
                let json = "{\"id\": " ++ (String.fromInt id) ++ ", \"name\": \"" ++ name ++ "\"}"
                    parsed = JD.decodeString Tag.decoder json
                    should = Ok <| Tag id name
                in Expect.equal should parsed
        , Test.fuzz (Fuzz.tuple (Fuzz.tuple3 (url, url, url), Fuzz.bool)) "fuzz the ModFile decoder" <|
            \((beth, steam, nexus), cc) ->
                let should = Ok <| ModFile beth nexus steam cc
                    parsed = JD.decodeString ModFile.decoder json
                in Expect.equal parsed should
        ]

url : Fuzzer (Maybe Url)
url =
    let fuz_query_params = Fuzz.tuple (Fuzz.string, Fuzz.string) |> Fuzz.map (\(a,b) -> Url.Builder.string a b)
        parse = \(a,b,c) -> Url.Builder.crossOrigin a b c |> Url.fromString
    in Fuzz.map parse <| Fuzz.tuple3 (Fuzz.string, Fuzz.list Fuzz.string, Fuzz.list fuz_query_params)



