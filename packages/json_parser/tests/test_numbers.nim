import unittest
import ../src/json_parser

# Number parsing tests ported from TypeScript
# These tests verify comprehensive number parsing functionality

suite "Number Parsing":

  test "should parse integer 123":
    let result = parseJson("123")
    check result.kind == JNumber
    check result.numberValue == 123.0

  test "should parse negative integer -42":
    let result = parseJson("-42")
    check result.kind == JNumber
    check result.numberValue == -42.0

  test "should parse decimal 3.14":
    let result = parseJson("3.14")
    check result.kind == JNumber
    check result.numberValue == 3.14

  test "should parse scientific notation 1e3":
    let result = parseJson("1e3")
    check result.kind == JNumber
    check result.numberValue == 1000.0

  test "should parse large positive exponent 1e10":
    let result = parseJson("1e10")
    check result.kind == JNumber
    check result.numberValue == 10000000000.0

  test "should parse negative exponent 2e-3":
    let result = parseJson("2e-3")
    check result.kind == JNumber
    check result.numberValue == 0.002

  test "should parse zero":
    let result = parseJson("0")
    check result.kind == JNumber
    check result.numberValue == 0.0

  test "should parse negative zero":
    let result = parseJson("-0")
    check result.kind == JNumber
    check result.numberValue == 0.0

  test "should parse number with leading/trailing whitespace":
    let result = parseJson("   42  ")
    check result.kind == JNumber
    check result.numberValue == 42.0

  test "should parse small decimal":
    let result = parseJson("0.00001")
    check result.kind == JNumber
    check result.numberValue == 0.00001

  test "should parse large number":
    let result = parseJson("123456789012345")
    check result.kind == JNumber
    check result.numberValue == 123456789012345.0

  test "should parse negative decimal":
    let result = parseJson("-3.14")
    check result.kind == JNumber
    check result.numberValue == -3.14

  test "should parse scientific notation with negative exponent":
    let result = parseJson("2e-2")
    check result.kind == JNumber
    check result.numberValue == 0.02

  test "should parse large negative exponent":
    let result = parseJson("2e-10")
    check result.kind == JNumber
    check result.numberValue == 2e-10

  test "should parse positive exponent":
    let result = parseJson("1e5")
    check result.kind == JNumber
    check result.numberValue == 100000.0

  test "should parse multi-digit exponent":
    let result = parseJson("1e12")
    check result.kind == JNumber
    check result.numberValue == 1e12

  test "should parse number with delimiter context":
    # Test parsing number when it might be followed by delimiter (like in array/object)
    let result = parseJson("123")
    check result.kind == JNumber
    check result.numberValue == 123.0

  test "should parse negative decimal in delimiter context":
    # Test parsing negative decimal when it might be followed by delimiter
    let result = parseJson("-3.14")
    check result.kind == JNumber
    check result.numberValue == -3.14

  # Error handling tests
  test "should throw on invalid input":
    expect(ValueError):
      discard parseJson("abc")

  test "should throw on incomplete exponent":
    expect(ValueError):
      discard parseJson("1e")

  test "should throw on invalid character after exponent":
    expect(ValueError):
      discard parseJson("1eA")
    expect(ValueError):
      discard parseJson("2E-")
    expect(ValueError):
      discard parseJson("3e+ ")
    expect(ValueError):
      discard parseJson("1.2e12E")
    expect(ValueError):
      discard parseJson("5e10X")

  test "should throw on plus sign":
    expect(ValueError):
      discard parseJson("+123")

  test "should throw on lone decimal":
    expect(ValueError):
      discard parseJson(".5")

  test "should throw on invalid mantissa":
    expect(ValueError):
      discard parseJson("1.-23")
    expect(ValueError):
      discard parseJson("1.2.3")

  test "should throw on NaN":
    expect(ValueError):
      discard parseJson("NaN")

  test "should throw on Infinity":
    expect(ValueError):
      discard parseJson("Infinity")

when isMainModule:
  echo "Running number parsing tests..."
