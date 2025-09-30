Write-Host "Building JSON Nim Monorepo (static)..."
New-Item -ItemType Directory -Force -Path build
Write-Host "Building json_parser (static)..."
nim c -d:release --cc:vcc --out:build/json_parser.static packages/json_parser/src/json_parser.nim
Write-Host "Building cli (static)..."
nim c -d:release --cc:vcc --out:build/json_cli.static packages/cli/src/json_cli.nim
Write-Host "Static binaries built in build/ directory as .static files"
