@echo off
echo Cleaning build artifacts...
for /r . %%f in (*.exe) do (
    echo Deleting %%f
    del "%%f" 2>nul
)
for /r . %%f in (*.pdb) do (
    echo Deleting %%f
    del "%%f" 2>nul
)
for /r . %%f in (*.ilk) do (
    echo Deleting %%f
    del "%%f" 2>nul
)
for /d /r . %%d in (nimcache) do (
    if exist "%%d" (
        echo Removing %%d
        rd /s /q "%%d" 2>nul
    )
)
echo Clean completed!