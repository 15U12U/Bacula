:: Created by Isuru Tharanga
:: Version 2.0-Mar 23, 2017

@echo off
title Bacula Backup and Restore
cls

:options
echo ================
echo Select an Option
echo ================
echo.
echo 1) Full Backup
echo 2) Incremental Backup
echo 3) Restore Backup
echo 4) Exit
echo.

set OPT=
set /p OPT=Option: %=%

if "%OPT%"=="1" goto full
if "%OPT%"=="2" goto incremental
if "%OPT%"=="3" goto restore
if "%OPT%"=="4" exit

echo.
echo Invalid Input! Please Enter a Valid Input [ex: 1/2/3/4]
echo.
goto options

:full
echo.
echo ====================
echo Starting Full Backup
echo ====================
echo.

cd C:\Program Files\Bacula\

>null.txt (
echo messages
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <null.txt >> mnull.txt

>full.txt (
echo run job=user_full yes
echo wait
echo messages
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <full.txt >> status.txt
echo.
echo =============
echo Backup Status
echo =============
echo.
type "C:\Program Files\Bacula\status.txt"

>recent.txt (
echo status client=user-fd
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <recent.txt >> rstatus.txt
echo.
echo =====================
echo Recent Backup/Restore
echo =====================
echo.
type "C:\Program Files\Bacula\rstatus.txt"
pause

del /f "C:\Program Files\Bacula\mnull.txt"
del /f "C:\Program Files\Bacula\full.txt"
del /f "C:\Program Files\Bacula\recent.txt"
del /f "C:\Program Files\Bacula\status.txt"
del /f "C:\Program Files\Bacula\rstatus.txt"
goto end


:incremental
echo.
echo ===========================
echo Starting Incremental Backup
echo ===========================
echo.

cd C:\Program Files\Bacula\

>null.txt (
echo messages
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <null.txt >> mnull.txt

>incremental.txt (
echo run job=user_incremental yes
echo wait
echo messages
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <incremental.txt >> status.txt
echo.
echo =============
echo Backup Status
echo =============
echo.
type "C:\Program Files\Bacula\status.txt"

>recent.txt (
echo status client=user-fd
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <recent.txt >> rstatus.txt
echo.
echo =====================
echo Recent Backup/Restore
echo =====================
echo.
type "C:\Program Files\Bacula\rstatus.txt"
pause

del /f "C:\Program Files\Bacula\mnull.txt"
del /f "C:\Program Files\Bacula\incremental.txt"
del /f "C:\Program Files\Bacula\recent.txt"
del /f "C:\Program Files\Bacula\status.txt"
del /f "C:\Program Files\Bacula\rstatus.txt"
goto end


:restore
echo.
echo =====================
echo Starting Full Restore
echo =====================
echo.

cd C:\Program Files\Bacula\

>null.txt (
echo messages
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <null.txt >> mnull.txt

>restore.txt (
echo restore client=user-fd select current all done yes
echo 10
echo wait
echo messages
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <restore.txt >> status.txt
echo.
echo ==============
echo Restore Status
echo ==============
echo.
type "C:\Program Files\Bacula\status.txt"

>recent.txt (
echo status client=user-fd
echo quit
)
bconsole.exe -c "C:\Program Files\Bacula\bconsole.conf" <recent.txt >> rstatus.txt
echo.
echo =====================
echo Recent Backup/Restore
echo =====================
echo.
type "C:\Program Files\Bacula\rstatus.txt"
pause

del /f "C:\Program Files\Bacula\mnull.txt"
del /f "C:\Program Files\Bacula\restore.txt"
del /f "C:\Program Files\Bacula\recent.txt"
del /f "C:\Program Files\Bacula\status.txt"
del /f "C:\Program Files\Bacula\rstatus.txt"
goto end


:end
exit
