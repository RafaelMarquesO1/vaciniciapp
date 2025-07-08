@echo off
echo ========================================
echo    VaciniciApp - Setup e Execucao
echo ========================================
echo.

REM Procurar Flutter em locais comuns
set FLUTTER_FOUND=0

REM Verificar se Flutter esta no PATH
flutter --version >nul 2>&1
if %errorlevel% equ 0 (
    set FLUTTER_CMD=flutter
    set FLUTTER_FOUND=1
    echo Flutter encontrado no PATH
    goto :found
)

REM Verificar locais comuns de instalacao
for %%p in (
    "C:\flutter\bin\flutter.bat"
    "C:\src\flutter\bin\flutter.bat"
    "C:\tools\flutter\bin\flutter.bat"
    "%USERPROFILE%\flutter\bin\flutter.bat"
    "%LOCALAPPDATA%\flutter\bin\flutter.bat"
) do (
    if exist %%p (
        set FLUTTER_CMD=%%p
        set FLUTTER_FOUND=1
        echo Flutter encontrado em %%p
        goto :found
    )
)

:found
if %FLUTTER_FOUND% equ 0 (
    echo.
    echo ❌ Flutter nao encontrado!
    echo.
    echo Por favor, instale o Flutter ou adicione ao PATH:
    echo 1. Baixe Flutter de: https://flutter.dev/docs/get-started/install/windows
    echo 2. Extraia para C:\flutter
    echo 3. Adicione C:\flutter\bin ao PATH do sistema
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Verificando versao do Flutter...
%FLUTTER_CMD% --version

echo.
echo 📦 Instalando dependencias...
%FLUTTER_CMD% pub get

if %errorlevel% neq 0 (
    echo.
    echo ❌ Erro ao instalar dependencias!
    pause
    exit /b 1
)

echo.
echo ✅ Dependencias instaladas com sucesso!
echo.
echo 🚀 Executando aplicativo...
echo   (Certifique-se de ter um emulador rodando ou dispositivo conectado)
echo.

%FLUTTER_CMD% run

echo.
echo Aplicativo finalizado.
pause