@echo off

:: Get the directory of the script
set "script_dir=%~dp0"

:: Set the source folder to the "current" folder inside the script directory
set "source_folder=%script_dir%current"

:: Set the manifest file path
set "manifest_file=%source_folder%\manifest.json"

:: Check if the "current" folder exists
if not exist "%source_folder%" (
    echo ERROR: The folder "current" does not exist in the script directory.
    pause
    exit /b
)

:: Check if the manifest file exists
if not exist "%manifest_file%" (
    echo ERROR: manifest.json file not found in the "current" folder.
    pause
    exit /b
)

:: Extract the "version" value from manifest.json
for /f "tokens=2 delims=:," %%A in ('findstr /i /c:"\"version\"" "%manifest_file%"') do (
    set "version=%%~A"
)

:: Remove any unwanted characters (e.g., quotes and spaces)
set "version=%version:"=%"

:: Set the destination zip file path
set "destination_zip=%script_dir%mod_%version%.zip"

:: Navigate to the source folder
cd /d "%source_folder%"

:: Check if the source folder contains any files or directories
dir /b >nul 2>&1
if errorlevel 1 (
    echo ERROR: The "current" folder is empty. No files to zip.
    pause
    exit /b
)

:: Create the zip file
::tar -a -cf "%destination_zip%" . >nul 2>&1
::tar -a -cf "%destination_zip%"
powershell -command "Compress-Archive -Path '%source_folder%\*' -DestinationPath '%destination_zip%'"

if errorlevel 1 (
    echo ERROR: Failed to create the zip file. Check the source folder contents.
) else (
    echo Zipping complete! Your zip is named mod_%version%.zip and is located at %script_dir%.
)

pause
