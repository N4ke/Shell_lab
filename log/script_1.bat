@echo off
setlocal enabledelayedexpansion

set "LOG_DIR=%~1"
set /a "TRESH_HOLD=%~2"
set /a "NUM_OF_FILES=%~3"
set "BACKUP_DIR=%LOG_DIR%backup"

for /f %%A in ('powershell -command "(Get-ChildItem -Path '%LOG_DIR%' -Recurse | Measure-Object -Property Length -Sum).Sum"') do set dir_size=%%A

for /f %%A in ('powershell -command "(Get-PSDrive -Name C).Used"') do set total_size=%%A

set /a "USAGE=dir_size*100/total_size"

set /a archive_count=1
for %%F in ("%BACKUP_DIR%\backup_*.tar") do set /a archive_count+=1
set "ARCHIVE_NAME=backup_%archive_count%.tar"

if %USAGE% geq %TRESH_HOLD% (
    echo ARCHIVATION...

    if not exist "%BACKUP_DIR%" (
        mkdir "%BACKUP_DIR%"
    )

    set /a count=0
    set "files_to_archive="
    for /f "delims=" %%i in ('dir /b /a-d /o-d "%LOG_DIR%\file_*.log"') do (
        set /a count+=1
        if !count! leq %NUM_OF_FILES% (
            set "files_to_archive=!files_to_archive! "%%i""
        )
    )

    if defined files_to_archive (
        tar -cvf "%BACKUP_DIR%\%ARCHIVE_NAME%" -C "%LOG_DIR%" !files_to_archive!
    ) else (
        echo No files found to archive.
    )
) else (
    echo USAGE IS %USAGE%, so no archivation required.
)

endlocal