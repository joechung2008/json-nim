# Create build directory if it doesn't exist
New-Item -ItemType Directory -Force -Path build | Out-Null

Write-Host "Running all tests..."

# Integration
nim c --cc:vcc --out:build/test_all --hints:off --verbosity:0 -r tests/test_all.nim

# CLI
nim c --cc:vcc --out:build/test_cli --hints:off --verbosity:0 -r packages/cli/tests/test_cli.nim

# JSON parser
$testFiles = Get-ChildItem -Path packages/json_parser/tests -Filter test_*.nim -Name
foreach ($file in $testFiles) {
    nim c --cc:vcc --hints:off --verbosity:0 --out:build/$($file.Replace('.nim','')).exe -r "packages/json_parser/tests/$file"
}
