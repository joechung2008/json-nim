@echo off
echo Building JSON Nim Monorepo (static)...
if not exist build mkdir build
echo Building json_parser (static)...
nim c -d:release --cc:vcc --out:build/json_parser_static packages/json_parser/src/json_parser.nim

echo Building cli (static)...
nim c -d:release --cc:vcc --out:build/json_cli_static packages/cli/src/json_cli.nim

echo Static binaries built in build/ directory as .static files
echo Static binaries built in build/ directory as _static files
