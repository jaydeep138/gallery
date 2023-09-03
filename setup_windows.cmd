@echo off
setlocal enabledelayedexpansion

:: Get the directory of the script
for %%I in (%0) do set SCRIPT_PATH=%%~dpI

:: Create a duplicate of each photo, and then minify them
:: Check for macOS
if "%OSTYPE%"=="darwin" (
    :: Check if sips is available
    where sips >nul 2>&1
    if !errorlevel!==0 (
        :: Low res version of image
        python "%SCRIPT_PATH%\tools\duplicate.py" min
        for /r "%SCRIPT_PATH%\photos\" %%F in (*.min.jpeg *.min.png *.min.jpg) do (
            sips -Z 640 "%%F" >nul 2>&1
        )

        :: Placeholder image for lazy loading
        python "%SCRIPT_PATH%\tools\duplicate.py" placeholder
        for /r "%SCRIPT_PATH%\photos\" %%F in (*.placeholder.jpeg *.placeholder.png *.placeholder.jpg) do (
            sips -Z 32 "%%F" >nul 2>&1
        )
    )
)

:: Check for Ubuntu
if "%OSTYPE%"=="linux" (
    :: Check if mogrify is available
    where mogrify >nul 2>&1
    if !errorlevel!==0 (
        :: Low res version of image
        python "%SCRIPT_PATH%\tools\duplicate.py" min
        for /r "%SCRIPT_PATH%\photos\" %%F in (*.min.jpeg *.min.png *.min.jpg) do (
            mogrify -resize 640x "%%F" >nul 2>&1
        )

        :: Placeholder image for lazy loading
        python "%SCRIPT_PATH%\tools\duplicate.py" placeholder
        for /r "%SCRIPT_PATH%\photos\" %%F in (*.placeholder.jpeg *.placeholder.png *.placeholder.jpg) do (
            mogrify -resize 32x "%%F" >nul 2>&1
        )
    )
)

:: Run the Python setup script
python "%SCRIPT_PATH%\tools\setup.py"

:: End of the script
exit /b 0
