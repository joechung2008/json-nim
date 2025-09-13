Write-Host "Building JSON Nim Monorepo..."
New-Item -ItemType Directory -Force -Path build
Write-Host "Building json_parser..."
nim c --cc:vcc --out:build/json_parser packages/json_parser/src/json_parser.nim
Write-Host "Building cli..."
nim c --cc:vcc --out:build/json_cli packages/cli/src/json_cli.nim
Write-Host "Binaries built in build/ directory"