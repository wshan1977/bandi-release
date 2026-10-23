@echo off
rem BANDI token navigation - update from GitHub, then start the PC tool.
rem The update (git reset) may replace this very file, and cmd reads a batch
rem file while running it - so run from a copy in %TEMP%.
if /i not "%~1"=="--run" (
  copy /y "%~f0" "%TEMP%\BANDI_Release_run.bat" >nul
  "%TEMP%\BANDI_Release_run.bat" --run "%~dp0."
)
chcp 65001 >nul
cd /d "%~2"
title BANDI 토큰 네비게이션
echo ==================================================
echo   반디 토큰 네비게이션 실행기
echo ==================================================

tasklist /FI "IMAGENAME eq bdci_manager.exe" 2>nul | "%SystemRoot%\System32\find.exe" /I "bdci_manager.exe" >nul
if not errorlevel 1 (
  echo 반디 토큰 네비게이션이 이미 실행 중입니다. 먼저 닫은 뒤 다시 실행하세요.
  "%SystemRoot%\System32\timeout.exe" /t 6 >nul
  exit /b
)

where git >nul 2>nul
if errorlevel 1 (
  echo [알림] git이 설치되어 있지 않아 업데이트 확인을 건너뜁니다.
  goto run
)
echo [1/3] 새 버전 확인 중... 새 버전이 있으면 내려받습니다. 수십 MB, 1~2분 걸릴 수 있습니다.
git fetch --progress origin main
if errorlevel 1 (
  echo [알림] 인터넷에 연결할 수 없어 현재 버전으로 실행합니다.
  goto run
)
echo [2/3] 업데이트 적용 중...
rem Binary mirror only - always match the published build exactly.
git reset --quiet --hard origin/main
git clean -fdq

:run
set VER=?
if exist pc_tool\version.txt set /p VER=<pc_tool\version.txt
echo [3/3] 반디 토큰 네비게이션 v%VER% 실행 중...
echo       업데이트 후 처음 실행할 때는 백신 검사 때문에 창이 뜨는 데 10~30초 걸릴 수 있습니다.
start "" "%CD%\pc_tool\bdci_manager.exe"
"%SystemRoot%\System32\timeout.exe" /t 5 >nul
