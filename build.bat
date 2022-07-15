rd .\target /S /Q
if errorlevel 1 (
    echo "Failed to clean previous build files, stop building."
    exit \B 1
)

mkdir .\target
xcopy .\src\resources .\target /s /e /y
if errorlevel 1 (
    echo "Failed to copy resources, stop building."
    exit \B 1
)

call .\compile.bat

if errorlevel 1 (
    echo "Failed to compile map script, stop building."
    exit \B 1
)

set MAP_FILE_NAME=dota

if exist ".\%MAP_FILE_NAME%.w3x" (
    del ".\%MAP_FILE_NAME%.w3x"
    if errorlevel 1 (
        echo "Failed to clean previous output, stop building."
        exit \B 1
    )
)

set MPQ_EDITOR_DIR=.\tools\mpqeditor
copy %MPQ_EDITOR_DIR%\empty.w3x .\%MAP_FILE_NAME%.w3x
if errorlevel 1 (
    echo "Failed to initialize map file, stop building."
    exit \B 1
)

%MPQ_EDITOR_DIR%\MPQEditor.exe add %MAP_FILE_NAME%.w3x target\*  /c /r
if errorlevel 1 (
    echo "Building failed."
    exit \B 1
)
