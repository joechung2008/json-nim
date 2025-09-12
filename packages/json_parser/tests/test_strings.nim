import unittest, strutils
import ../src/json_parser

# String parsing tests ported from TypeScript
# These tests verify comprehensive string parsing and escaping functionality

suite "String Parsing":

  test "should parse normal string and unescape":
    let result = parseJson("\"hello\"")
    check result.kind == JString
    check result.strValue == "hello"

  test "should parse empty string":
    let result = parseJson("\"\"")
    check result.kind == JString
    check result.strValue == ""

  test "should handle escaped quotes":
    let result = parseJson("\"he\\\"llo\"")
    check result.kind == JString
    check result.strValue == "he\"llo"

  test "should handle escaped backslash":
    let result = parseJson("\"he\\\\llo\"")
    check result.kind == JString
    check result.strValue == "he\\llo"

  test "should handle unicode escape \\u0041":
    let result = parseJson("\"hi\\u0041\"")
    check result.kind == JString
    check result.strValue == "hiA"

  test "should preserve internal whitespace":
    let result = parseJson("\"  spaced  \"")
    check result.kind == JString
    check result.strValue == "  spaced  "

  test "should handle newline escape":
    let result = parseJson("\"line\\nend\"")
    check result.kind == JString
    check result.strValue == "line\nend"

  test "should handle tab escape":
    let result = parseJson("\"tab\\tend\"")
    check result.kind == JString
    check result.strValue == "tab\tend"

  test "should handle multiple escapes":
    let result = parseJson("\"a\\nb\\tc\\\\\"")
    check result.kind == JString
    check result.strValue == "a\nb\tc\\"

  test "should handle long strings":
    let longStr = "\"" & "a".repeat(1000) & "\""
    let result = parseJson(longStr)
    check result.kind == JString
    check result.strValue.len == 1000

  test "should handle single character":
    let result = parseJson("\"x\"")
    check result.kind == JString
    check result.strValue == "x"

  test "should handle string with only escape":
    let result = parseJson("\"\\n\"")
    check result.kind == JString
    check result.strValue == "\n"

  test "should handle string with leading whitespace":
    let result = parseJson("   \"abc\"")
    check result.kind == JString
    check result.strValue == "abc"

  test "should handle backspace escape":
    let result = parseJson("\"a\\b\"")
    check result.kind == JString
    check result.strValue == "a\b"

  test "should handle form feed escape":
    let result = parseJson("\"a\\f\"")
    check result.kind == JString
    check result.strValue == "a\f"

  test "should handle carriage return escape":
    let result = parseJson("\"a\\r\"")
    check result.kind == JString
    check result.strValue == "a\r"

  test "should handle unicode escape sequence":
    let result = parseJson("\"A=\\u0041\"")
    check result.kind == JString
    check result.strValue == "A=A"

  test "should handle mixed escapes":
    let result = parseJson("\"mix\\n\\t\"")
    check result.kind == JString
    check result.strValue == "mix\n\t"

  # Error handling tests
  test "should throw on unescaped newline in string":
    expect(ValueError):
      discard parseJson("\"abc\ndef\"")

  test "should throw on invalid Unicode escape":
    expect(ValueError):
      discard parseJson("\"bad\\uZZZZ\"")

  test "should throw on incomplete escape":
    expect(ValueError):
      discard parseJson("\"bad\\")

  test "should throw on invalid escape":
    expect(ValueError):
      discard parseJson("\"bad\\xescape\"")

  test "should throw on missing opening quote":
    expect(ValueError):
      discard parseJson("hello\"")

  test "should throw on missing closing quote":
    expect(ValueError):
      discard parseJson("\"hello")

  test "should throw on incomplete Unicode escape":
    expect(ValueError):
      discard parseJson("\"hi\\u00\"")

when isMainModule:
  echo "Running string parsing tests..."
