$files = Get-ChildItem -Path packages, tests -Recurse -Filter *.nim
foreach ($file in $files) {
    nimpretty --indent:2 $file.FullName
}