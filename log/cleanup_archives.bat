@echo off

:cleanup
del /q "backup\backup_*.tar"
goto :eof

call :cleanup
