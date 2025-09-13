import unittest, tables
import ../src/json_parser

# Key-value pair parsing tests ported from TypeScript pair.test.ts
# These test object member parsing specifically

suite "Key-Value Pair Parsing":

  test "should parse valid key-value pair in object":
    let result = parseJson("{\"a\":1}")
    check result.kind == JObject
    check result.objValue.hasKey("a")
    check result.objValue["a"].kind == JNumber
    check result.objValue["a"].numberValue == 1.0

  test "should parse multiple key-value pairs":
    let result = parseJson("{\"key1\":\"value1\",\"key2\":42}")
    check result.kind == JObject
    check result.objValue["key1"].strValue == "value1"
    check result.objValue["key2"].numberValue == 42.0

  # Error handling tests for malformed key-value pairs
  test "should throw on missing colon":
    expect(ValueError):
      discard parseJson("{\"a\" 1}")

  test "should throw on missing key":
    expect(ValueError):
      discard parseJson("{:1}")

  test "should throw on missing value":
    expect(ValueError):
      discard parseJson("{\"a\":}")

  test "should throw on incomplete key-value expression":
    expect(ValueError):
      discard parseJson("{\"a\"}")
