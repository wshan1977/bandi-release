@echo off
chcp 65001 >nul
rem BANDI token navigation - update from GitHub, then start the PC tool.
cd /d "%~dp0"

tasklist /FI "IMAGENAME eq bdci_manager.exe" 2>nul | find /I "bdci_manager.exe" >nul
if not errorlevel 1 (
  echo 반디 토큰 네비게이션이 이미 실행 중입니다. 먼저 닫은 뒤 다시 실행하세요.
  timeout /t 6 >nul
  exit /b
)

where git >nul 2>nul
if errorlevel 1 (
  echo [알림] git이 설치되어 있지 않아 업데이트 확인을 건너뜁니다.
  goto run
)
echo 최신 버전 확인 중...
git fetch --quiet origin main
if errorlevel 1 (
  echo [알림] 인터넷에 연결할 수 없어 현재 버전으로 실행합니다.
  goto run
)
rem Binary mirror only - always match the published build exactly.
git reset --quiet --hard origin/main
git clean -fdq
set /p VER=<pc_tool\version.txt
echo 반디 토큰 네비게이션 v%VER%

:run
start "" "%~dp0pc_tool\bdci_manager.exe"
