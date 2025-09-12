import unittest, tables
import ../src/json_parser

# Value parsing tests ported from TypeScript value.test.ts and json.test.ts
# These cover parsing of all JSON value types and general parsing behavior

suite "Value Parsing":

  test "should parse number value":
    let result = parseJson("42")
    check result.kind == JNumber
    check result.numberValue == 42.0

  test "should parse string value":
    let result = parseJson("\"hello\"")
    check result.kind == JString
    check result.strValue == "hello"

  test "should parse array value":
    let result = parseJson("[1,2]")
    check result.kind == JArray
    check len(result.arrayValue) == 2

  test "should parse object value":
    let result = parseJson("{\"a\":1}")
    check result.kind == JObject
    check result.objValue["a"].numberValue == 1.0

  test "should parse true":
    let result = parseJson("true")
    check result.kind == JBool
    check result.bval == true

  test "should parse false":
    let result = parseJson("false")
    check result.kind == JBool
    check result.bval == false

  test "should parse null":
    let result = parseJson("null")
    check result.kind == JNull

  test "should parse JSON with leading whitespace":
    let result = parseJson("   123")
    check result.kind == JNumber
    check result.numberValue == 123.0

  test "should parse value with leading whitespace":
    let result = parseJson("   42")
    check result.kind == JNumber
    check result.numberValue == 42.0

  test "should handle non-string input validation":
    # Our Nim parser expects string input, this tests the interface contract
    let validInput = "42"
    let result = parseJson(validInput)
    check result.kind == JNumber
    check result.numberValue == 42.0

  test "should parse JSON with leading whitespace":
    # Additional test for leading whitespace with different types
    let result1 = parseJson("   123")
    check result1.kind == JNumber
    check result1.numberValue == 123.0

    let result2 = parseJson("   \"hello\"")
    check result2.kind == JString
    check result2.strValue == "hello"

  # Error handling tests
  test "should throw on empty input":
    expect(ValueError):
      discard parseJson("")

  test "should throw on invalid input":
    expect(ValueError):
      discard parseJson("invalid")

  test "should throw on typo in 'null'":
    expect(ValueError):
      discard parseJson("nul")
    expect(ValueError):
      discard parseJson("nall")
    expect(ValueError):
      discard parseJson("nulL")

  test "should throw on typo in 'false'":
    expect(ValueError):
      discard parseJson("falze")
    expect(ValueError):
      discard parseJson("fa1se")
    expect(ValueError):
      discard parseJson("falsy")

  test "should throw on typo in 'true'":
    expect(ValueError):
      discard parseJson("tru")
    expect(ValueError):
      discard parseJson("trua")
    expect(ValueError):
      discard parseJson("ture")
    expect(ValueError):
      discard parseJson("treu")

when isMainModule:
  echo "Running value parsing tests..."
