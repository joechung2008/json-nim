# Package

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
  exec "nim c --out:../../build/test_numbers --hints:off --verbosity:0 -r tests/test_numbers.nim"
  exec "nim c --out:../../build/test_strings --hints:off --verbosity:0 -r tests/test_strings.nim"
  exec "nim c --out:../../build/test_arrays --hints:off --verbosity:0 -r tests/test_arrays.nim"
  exec "nim c --out:../../build/test_objects --hints:off --verbosity:0 -r tests/test_objects.nim"
  exec "nim c --out:../../build/test_values --hints:off --verbosity:0 -r tests/test_values.nim"
  exec "nim c --out:../../build/test_pairs --hints:off --verbosity:0 -r tests/test_pairs.nim"
  echo "All JSON parser tests completed"