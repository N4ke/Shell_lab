@echo off
setlocal

set "LOG_DIR=%~1"

call :test_1
call :test_2
call :test_3
call :test_4

:generate_files
set "file_count=%1"
set "file_size=%2"

for /L %%i in (1,1,%file_count%) do (
    fsutil file createnew "%LOG_DIR%\file_%%i.log" %file_size%000000
    powershell -Command "(Get-Item '%LOG_DIR%\file_%%i.log').LastWriteTime = (Get-Date).AddDays(- (Get-Random -Minimum 1 -Maximum 20))"
)

exit /b

:cleanup
del /Q "%LOG_DIR%/file_*.log"
exit /b

:test_1
echo Test 1...(Current usage ^< N)...Generating 5 files of 200 MB
call :generate_files 5 200
call %LOG_DIR%/script_1.bat %LOG_DIR% 99 1
call :cleanup
echo ==================================
exit /b

:test_2
echo Test 2...(Current usage ^> N)...Generating 5 files of 200 MB
call :generate_files 5 200
call %LOG_DIR%/script_1.bat %LOG_DIR% 0 5
call :cleanup
echo ==================================
exit /b

:test_3
echo Test 3...(Current usage ^> N, but number of files ^< X)...Generating 2 files of 1 GB
call :generate_files 2 1000
call %LOG_DIR%/script_1.bat %LOG_DIR% 0 5
call :cleanup
echo ==================================
exit /b

:test_4
echo Test 4...(Stress test, current usage ^> N)...Generating 50 files of 10 MB
call :generate_files 50 10
call %LOG_DIR%/script_1.bat %LOG_DIR% 0 40
call :cleanup
echo ==================================
exit /b

endlocal