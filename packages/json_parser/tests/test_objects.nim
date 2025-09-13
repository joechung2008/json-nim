import unittest, tables
import ../src/json_parser

suite "Object Parsing":

  test "should parse empty object":
    let result = parseJson("{}")
    check result.kind == JObject
    check len(result.objValue) == 0

  test "should parse single key-value pair":
    let result = parseJson("{\"a\":1}")
    check result.kind == JObject
    check result.objValue.hasKey("a")
    check result.objValue["a"].kind == JNumber
    check result.objValue["a"].numberValue == 1.0

  test "should parse multiple key-value pairs":
    let result = parseJson("{\"a\":1,\"b\":2}")
    check result.kind == JObject
    check len(result.objValue) == 2
    check result.objValue["a"].numberValue == 1.0
    check result.objValue["b"].numberValue == 2.0

  test "should parse object with whitespace":
    let result = parseJson("  {  \"a\"  :  1  ,  \"b\"  :  2  }  ")
    check result.kind == JObject
    check len(result.objValue) == 2
    check result.objValue["a"].numberValue == 1.0
    check result.objValue["b"].numberValue == 2.0

  test "should parse nested objects":
    let result = parseJson("{\"outer\":{\"inner\":42}}")
    check result.kind == JObject
    check result.objValue["outer"].kind == JObject
    check result.objValue["outer"].objValue["inner"].numberValue == 42.0

  test "should parse object with array":
    let result = parseJson("{\"numbers\":[1,2,3]}")
    check result.kind == JObject
    check result.objValue["numbers"].kind == JArray
    check result.objValue["numbers"].arrayValue.len == 3

  test "should parse object with mixed types":
    let result = parseJson("{\"num\":42,\"str\":\"hello\",\"bool\":true,\"null\":null}")
    check result.kind == JObject
    check result.objValue["num"].kind == JNumber
    check result.objValue["num"].numberValue == 42.0
    check result.objValue["str"].kind == JString
    check result.objValue["str"].strValue == "hello"
    check result.objValue["bool"].kind == JBool
    check result.objValue["bool"].bval == true
    check result.objValue["null"].kind == JNull

  test "should parse object with string values":
    let result = parseJson("{\"key1\":\"value1\",\"key2\":\"value2\"}")
    check result.kind == JObject
    check result.objValue["key1"].strValue == "value1"
    check result.objValue["key2"].strValue == "value2"

  test "should parse object with extra whitespace":
    let result = parseJson("  {  \"a\"  :  1  ,  \"b\"  :  2  }  ")
    check result.kind == JObject
    check len(result.objValue) == 2
    check result.objValue["a"].numberValue == 1.0
    check result.objValue["b"].numberValue == 2.0

  # Error handling tests
  test "should throw on invalid key-value pair ending":
    expect(ValueError):
      discard parseJson("{\"a\":1; \"b\":2}")
    expect(ValueError):
      discard parseJson("{\"a\":1. \"b\":2}")

  test "should throw on missing opening brace":
    expect(ValueError):
      discard parseJson("\"a\":1}")

  test "should throw on missing closing brace":
    expect(ValueError):
      discard parseJson("{\"a\":1")

  test "should throw on trailing comma":
    expect(ValueError):
      discard parseJson("{\"a\":1,}")
