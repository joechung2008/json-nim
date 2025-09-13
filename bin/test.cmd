@echo off
setlocal enabledelayedexpansion
echo Running all tests...
nim c --cc:vcc --out:build/test_all --hints:off --verbosity:0 -r tests/test_all.nim
nim c --cc:vcc --out:build/test_cli --hints:off --verbosity:0 -r packages/cli/tests/test_cli.nim
pushd packages\json_parser\tests
for %%f in (test_*.nim) do (
    set "file=%%~nf"
    nim c --cc:vcc --hints:off --verbosity:0 --out:..\..\build\!file!.exe -r "%%f"
)
popd