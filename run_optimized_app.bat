@echo off
echo ========================================
echo    VaciniciApp - Versao Otimizada
echo ========================================
echo.
echo Verificando Flutter...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter nao encontrado no PATH.
    echo Tentando usar caminho padrao...
    set FLUTTER_PATH=C:\flutter\bin\flutter
) else (
    set FLUTTER_PATH=flutter
)

echo.
echo Instalando dependencias...
%FLUTTER_PATH% pub get
echo.
echo Executando aplicativo...
%FLUTTER_PATH% run
pause