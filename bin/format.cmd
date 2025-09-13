@echo off
for /r packages %%f in (*.*) do if "%%~xf"==".nim" nimpretty --indent:2 "%%f"
for /r tests %%f in (*.*) do if "%%~xf"==".nim" nimpretty --indent:2 "%%f"