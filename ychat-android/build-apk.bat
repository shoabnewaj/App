@echo off
echo ===================================================
echo   Building Y-ChatApp Android APK
echo ===================================================

if exist gradlew.bat (
    call gradlew.bat assembleDebug
) else (
    echo Gradle wrapper not found. Opening Android Studio or running gradle...
    gradle assembleDebug
)

if exist app\build\outputs\apk\debug\app-debug.apk (
    echo.
    echo ===================================================
    echo   BUILD SUCCESS!
    echo   Your installable APK is ready:
    echo   ychat-android\app\build\outputs\apk\debug\app-debug.apk
    echo ===================================================
) else (
    echo.
    echo Please open the 'ychat-android' folder in Android Studio
    echo and click: Build > Build Bundle(s) / APK(s) > Build APK(s)
)
pause
