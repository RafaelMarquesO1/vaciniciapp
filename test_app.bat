@echo off
echo ========================================
echo    VaciniciApp - Teste Completo
echo ========================================
echo.
echo Limpando cache...
flutter clean
echo.
echo Instalando dependencias...
flutter pub get
echo.
echo Executando aplicativo...
flutter run --debug
pause