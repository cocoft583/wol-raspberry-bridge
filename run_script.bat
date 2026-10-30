@echo off
rem Equivalente a run_script.sh para Windows: usa el Python del entorno virtual
rem de esta misma carpeta, así que no hace falta activarlo.
"%~dp0.venv\Scripts\python.exe" "%~dp0src\ScriptPC.py"
exit /b %ERRORLEVEL%
