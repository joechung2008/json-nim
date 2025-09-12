import unittest
import ../src/json_parser

suite "Array Parsing":

  test "should parse empty array":
    let result = parseJson("[]")
    check result.kind == JArray
    check len(result.arrayValue) == 0

  test "should parse single element array":
    let result = parseJson("[1]")
    check result.kind == JArray
    check len(result.arrayValue) == 1
    check result.arrayValue[0].kind == JNumber
    check result.arrayValue[0].numberValue == 1.0

  test "should parse multi-element array":
    let result = parseJson("[1, 2, 3]")
    check result.kind == JArray
    check len(result.arrayValue) == 3
    check result.arrayValue[0].numberValue == 1.0
    check result.arrayValue[1].numberValue == 2.0
    check result.arrayValue[2].numberValue == 3.0

  test "should parse mixed type array":
    let result = parseJson("[1, \"hello\", true, null]")
    check result.kind == JArray
    check len(result.arrayValue) == 4
    check result.arrayValue[0].kind == JNumber
    check result.arrayValue[0].numberValue == 1.0
    check result.arrayValue[1].kind == JString
    check result.arrayValue[1].strValue == "hello"
    check result.arrayValue[2].kind == JBool
    check result.arrayValue[2].bval == true
    check result.arrayValue[3].kind == JNull

  test "should parse array with extra whitespace":
    let result = parseJson("[  1  ,   2 , 3   ]")
    check result.kind == JArray
    check len(result.arrayValue) == 3
    check result.arrayValue[0].numberValue == 1.0
    check result.arrayValue[1].numberValue == 2.0
    check result.arrayValue[2].numberValue == 3.0

  test "should parse array with leading whitespace":
    let result = parseJson("   [1,2,3]")
    check result.kind == JArray
    check len(result.arrayValue) == 3
    check result.arrayValue[0].numberValue == 1.0
    check result.arrayValue[1].numberValue == 2.0
    check result.arrayValue[2].numberValue == 3.0

  # Error handling tests
  test "should throw on invalid delimiter between elements":
    expect(ValueError):
      discard parseJson("[1;2]")
    expect(ValueError):
      discard parseJson("[1 2]")

  test "should throw on missing opening bracket":
    expect(ValueError):
      discard parseJson("1,2,3]")

  test "should throw on missing closing bracket":
    expect(ValueError):
      discard parseJson("[1,2,3")

  test "should throw on trailing comma":
    expect(ValueError):
      discard parseJson("[1,2,]")

when isMainModule:
  echo "Running array parsing tests..."
