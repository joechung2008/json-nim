# Package

version       = "0.1.0"
author        = "Joe Chung"
description   = "A CLI tool for parsing JSON from stdin"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]

# Dependencies

requires "nim >= 1.6.0"

# Binary targets

bin = @["json_cli"]

task test, "Run the tests":
  echo "Running CLI tests..."
  mkDir("../../build")
  exec "nim c --out:../../build/test_cli -r tests/test_cli.nim"
  echo "CLI tests completed"