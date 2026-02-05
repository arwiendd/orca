@REM Confabric Slicer - Quick Rebuild Script
@REM Deps'i tekrar derlemeden sadece slicer'i derler
@echo off

set WP=%CD%

REM CMake PATH ayari (Strawberry Perl cakismasi icin)
set PATH=C:\Program Files\CMake\bin;%PATH%

REM Visual Studio 2022 ortamini yukle
if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" (
    call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -arch=x64
) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat" (
    call "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\Tools\VsDevCmd.bat" -arch=x64
) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat" (
    call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\VsDevCmd.bat" -arch=x64
)

REM Build type secimi
set build_type=Release
set build_dir=build

if "%1"=="debug" (
    set build_type=Debug
    set build_dir=build-dbg
)
if "%1"=="debuginfo" (
    set build_type=RelWithDebInfo
    set build_dir=build-dbginfo
)

echo ========================================
echo Confabric Slicer - Hizli Yeniden Derleme
echo Build Type: %build_type%
echo Build Dir: %build_dir%
echo ========================================

REM Build klasorune git
cd %WP%\%build_dir%

if not exist "CMakeCache.txt" (
    echo HATA: CMakeCache.txt bulunamadi!
    echo Once tam build yapin: build_release_vs2022.bat
    pause
    exit /b 1
)

echo.
echo [1/2] Derleme basliyor...
cmake --build . --config %build_type% --target ALL_BUILD -- -m

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo HATA: Derleme basarisiz!
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [2/2] Install yapiliyor...
cmake --build . --target install --config %build_type%

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo HATA: Install basarisiz!
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo Derleme basarili!
echo Calistirmak icin: %build_dir%\src\%build_type%\confabric-slicer.exe
echo ========================================
pause
