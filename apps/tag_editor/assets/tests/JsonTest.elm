module JsonTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Json.Decode as JD
import Json.Encode as JE
import Mod exposing (Mod)
import ModFile exposing (ModFile)
import MoreFuzzer
import Tag exposing (Tag)
import Test exposing (Test)


suite : Test
suite =
    Test.describe "fuzz the json decoder functions. these test are self contained, so only fuzz what json is created should create the same value again"
        [ jsonFuzzer { desc = "fuzz Tag", fuzzer = MoreFuzzer.tag, enc = Tag.encode, dec = Tag.decoder }
        , jsonFuzzer { desc = "fuzz ModFile", fuzzer = MoreFuzzer.modFile, enc = ModFile.encode, dec = ModFile.decoder }
        , jsonFuzzer { desc = "fuzz Mod", fuzzer = MoreFuzzer.mod, enc = Mod.encode, dec = Mod.decoder }
        ]


jsonFuzzer : { desc : String, fuzzer : Fuzzer t, enc : t -> JE.Value, dec : JD.Decoder t } -> Test
jsonFuzzer args =
    Test.fuzz args.fuzzer args.desc <|
        \val ->
            let
                encoded =
                    JE.encode 0 (args.enc val)

                decoded =
                    JD.decodeString args.dec encoded
            in
            case decoded of
                Ok jback ->
                    Expect.equal jback val

                Err err ->
                    Expect.fail <| JD.errorToString err
