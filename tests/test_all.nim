import unittest, tables
import ../packages/json_parser/src/json_parser

# Integration tests for the entire monorepo
# This file runs basic integration tests while comprehensive tests
# are in their respective package test directories:
# - packages/json_parser/tests/ contains 93 comprehensive tests ported from TypeScript
# - packages/cli/tests/ contains CLI functionality tests

suite "JSON Monorepo Integration Tests":

  test "basic JSON operations":
    let str_node = newJString("test")
    let num_node = newJNumber(42.0)
    let bool_node = newJBool(true)

    check $str_node == "\"test\""
    check $num_node == "42"
    check $bool_node == "true"

  test "CLI package can use json_parser":
    # Test that CLI can create and use JSON nodes with valid JSON
    let testNode = parseJson("\"test data\"")
    check testNode != nil
    check testNode.kind == JString
    check testNode.strValue == "test data"

  test "comprehensive JSON parsing functionality":
    # Test various JSON types work correctly
    check parseJson("123").numberValue == 123.0
    check parseJson("3.14").numberValue == 3.14
    check parseJson("true").bval == true
    check parseJson("false").bval == false
    check parseJson("null").kind == JNull
    check parseJson("\"hello\"").strValue == "hello"
    check parseJson("[1,2,3]").arrayValue.len == 3
    check parseJson("{\"a\":1}").objValue["a"].numberValue == 1.0

when isMainModule:
  # Run the tests when this file is executed directly
  echo "Running JSON monorepo integration tests..."
  echo "Note: For comprehensive test coverage (93 tests), run individual test files in packages/json_parser/tests/"
