@echo off

call :cleanup

:cleanup
del /q "backup\backup_*.tar"
exit /b
