@echo off
setlocal enabledelayedexpansion

:: ======================================================================
:: CONFIGURATION
:: Adjust the executable name to match the CLI tool on your USB drive.
set "CLI_EXE=mediaexplorer-cli-x86_64-pc-windows-msvc.exe"
:: ======================================================================

:: Change to the directory where the batch script resides (USB Root)
cd /d "%~dp0"

if not exist "%CLI_EXE%" (
    echo [ERROR] "%CLI_EXE%" not found in the current directory.
    echo Please update the CLI_EXE variable in this script to match the tool.
    pause
    exit /b
)

:: 1. Identify .img files
set "count=0"
for %%I in (*.img) do (
    set /a count+=1
    set "img[!count!]=%%I"
)

if %count%==0 (
    echo No .img files found on the USB drive.
    pause
    exit /b
)

:: 2. Handle selection logic
if %count%==1 (
    set "TARGET_IMG=!img[1]!"
    echo Found single image: !TARGET_IMG!
) else (
    echo Multiple .img files found:
    for /L %%N in (1, 1, %count%) do (
        echo   %%N. !img[%%N]!
    )
    echo.
    set "choice="
    set /p choice="Select the number of the image to process: "
    
    :: Validate input
    call set "TARGET_IMG=%%img[!choice!]%%"
    if "!TARGET_IMG!"=="" (
        echo Invalid selection. Exiting.
        pause
        exit /b
    )
    echo Selected image: !TARGET_IMG!
)

:: 3. Setup temporary safe extraction folder
set "TMP_DIR=%CD%\.tmp_extract"
:: Clean it up first if it already exists from a previous aborted run
if exist "%TMP_DIR%" rmdir /s /q "%TMP_DIR%" 2>nul
mkdir "%TMP_DIR%"

echo.
echo Extracting all files from "!TARGET_IMG!"...

:: 4. Extract all files to the temporary directory
"%CLI_EXE%" extract "!TARGET_IMG!" --out "%TMP_DIR%"

:: 5. Process extracted files individually
set "files_found=0"
for %%F in ("%TMP_DIR%\*") do (
    set "files_found=1"
    :: Pass only the filename and extension to the subroutine
    call :ProcessFile "%%~nxF"
)

if "!files_found!"=="0" (
    echo No files were found in the image, or extraction failed.
)

:: Cleanup
rmdir /s /q "%TMP_DIR%" 2>nul
echo.
echo All operations completed.
pause
exit /b

:: ======================================================================
:: Subroutine: Move to root (with collision handling) and safe delete
:ProcessFile
set "filename=%~1"
set "base_name=%~n1"
set "ext=%~x1"
set "dest_name=%~1"

echo.
echo ----------------------------------------
echo Processing: !filename!

:: Step A: Prevent overwrites in USB root
:: Loop structure flattened to avoid 'goto' inside parentheses
set "counter=1"

:CheckCollision
if not exist "!dest_name!" goto CollisionResolved
set "dest_name=!base_name!_!counter!!ext!"
set /a counter+=1
goto CheckCollision

:CollisionResolved
:: Step B: Safely move to the USB root
move /Y "%TMP_DIR%\!filename!" "!dest_name!" >nul

:: Step C: Verify the move before deleting from the image
if exist "!dest_name!" (
    echo [SUCCESS] Saved to USB as "!dest_name!".
    echo           Removing "!filename!" from the image...
    
    :: Use the 'rm' switch to delete the file from the image
    "%CLI_EXE%" rm "!TARGET_IMG!" "!filename!" >nul 2>&1
) else (
    echo [ERROR] Could not secure file to USB root. Safety delete aborted.
)

exit /b