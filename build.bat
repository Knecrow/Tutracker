@echo off
REM Build Tutracker APK with automatic naming

echo Building Tutracker APK...
call flutter build apk --release

if %errorlevel% equ 0 (
    echo Build successful, renaming APK...
    set "oldPath=build\app\outputs\flutter-apk\app-release.apk"
    set "newPath=build\app\outputs\flutter-apk\Tutracker-1.0.0.apk"
    
    if exist "%oldPath%" (
        powershell -Command "Move-Item -Path '%oldPath%' -Destination '%newPath%' -Force"
        echo.
        echo APK successfully created: %newPath%
        echo.
    )
) else (
    echo Build failed!
    exit /b 1
)
