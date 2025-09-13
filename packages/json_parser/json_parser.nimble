# Package

import std/[os, strutils]

version       = "0.1.0"
author        = "Joe Chung"
description   = "A JSON parser library"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]

# Dependencies

requires "nim >= 1.6.0"

# Binary targets

bin = @["json_parser"]

task test, "Run the tests":
  echo "Running JSON parser tests..."
  mkDir("../../build")
  for testFile in listFiles("tests"):
    if testFile.endsWith(".nim"):
      let testName = testFile.splitFile.name
      exec "nim c --out:../../build/" & testName & " --hints:off --verbosity:0 -r " & testFile