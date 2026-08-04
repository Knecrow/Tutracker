#!/usr/bin/env pwsh
<#
.SYNOPSIS
Build Tutracker APK with automatic naming
.DESCRIPTION
Builds the Flutter APK and automatically renames it to Tutracker-1.0.0.apk
#>

Write-Host "Building Tutracker APK..." -ForegroundColor Cyan
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful, renaming APK..." -ForegroundColor Green
    $oldPath = "build\app\outputs\flutter-apk\app-release.apk"
    $newPath = "build\app\outputs\flutter-apk\Tutracker-1.0.0.apk"
    
    if (Test-Path $oldPath) {
        Move-Item -Path $oldPath -Destination $newPath -Force
        Write-Host "`n✓ APK successfully created: $newPath`n" -ForegroundColor Green
    }
} else {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}
