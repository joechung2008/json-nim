@echo off
cd packages\json_parser
nimble install -d
cd ..\cli
nimble install -d
cd ..\..