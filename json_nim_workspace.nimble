# Package

version       = "0.1.0"
author        = "Joe Chung"
description   = "JSON parser in Nim"
license       = "MIT"
srcDir        = "."

# Dependencies

requires "nim >= 1.6.0"

# Tasks for the monorepo

task build_all, "Build all packages":
  echo "Building JSON Nim Monorepo..."
  mkDir("build")  # Create build directory
  echo "Building json_parser..."
  exec "nim c --out:build/json_parser packages/json_parser/src/json_parser.nim"
  echo "Building cli..."
  exec "nim c --out:build/json_cli packages/cli/src/json_cli.nim"
  echo "Binaries built in build/ directory"

task test, "Run all tests":
  echo "Running all tests..."
  exec "nim c --out:build/test_all --hints:off --verbosity:0 -r tests/test_all.nim"
  exec "cd packages/json_parser && nimble test"

task build_and_test, "Build all packages and run tests":
  echo "Building and testing JSON Nim Monorepo..."
  exec "nimble build_all"
  exec "nimble test"
  echo "Build and test completed successfully!"
  
task install_deps, "Install dependencies for all packages":
  exec "cd packages/json_parser && nimble install -d"
  exec "cd packages/cli && nimble install -d"

task clean, "Clean all build artifacts":
  echo "Cleaning build artifacts..."
  when defined(windows):
    exec "del /Q /S *.exe 2>nul || echo No exe files found"
    exec "for /D /R . %d in (nimcache) do @if exist \"%d\" rd /S /Q \"%d\""
  else:
    exec "find . -name '*.exe' -delete 2>/dev/null || true"
    exec "find . -name 'nimcache' -type d -exec rm -rf {} + 2>/dev/null || true"
  echo "Clean completed!"

task docs, "Generate documentation for all packages":
  exec "cd packages/json_parser && nim doc --project --outdir:../../docs src/json_parser.nim"
  exec "cd packages/cli && nim doc --project --outdir:../../docs src/json_cli.nim"
  echo "Documentation generated!"

task format, "Format all Nim files using nimpretty":
  echo "Formatting all Nim files..."
  when defined(windows):
    exec "for /R . %f in (*.nim) do nimpretty \"%f\""
  else:
    exec "find . -name '*.nim' -exec nimpretty {} \\;"
  echo "Format task completed"
