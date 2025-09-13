@echo off
cd packages\json_parser
nim doc --project --outdir:..\..\docs src\json_parser.nim
cd ..\..