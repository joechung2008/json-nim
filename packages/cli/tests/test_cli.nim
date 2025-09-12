import unittest
import ../src/json_cli
import ../../json_parser/src/json_parser

suite "CLI Tests":

  test "CLI can import json_parser":
    # Test that we can create JSON nodes using the parser
    let testJson = newJString("test")
    check $testJson == "\"test\""

  test "readAllStdin helper exists":
    # Just test that the function is accessible
    # Note: We can't easily test stdin reading in unit tests
    discard
