@echo off
echo Building and testing JSON Nim Monorepo...
call bin\build_all.cmd
call bin\test.cmd
echo Build and test completed successfully!