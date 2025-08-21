@echo off
echo ========================================
echo    VACINICI APP - VERSAO INTEGRADA
echo ========================================
echo.

echo Verificando se o backend esta rodando...
curl -s http://localhost:8080/api/usuarios >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ ERRO: Backend nao esta rodando!
    echo.
    echo Por favor, inicie o backend primeiro:
    echo 1. Abra um terminal na pasta vacinici-backend
    echo 2. Execute: run.bat
    echo 3. Aguarde o backend iniciar na porta 8080
    echo 4. Execute este script novamente
    echo.
    pause
    exit /b 1
)

echo ✅ Backend detectado na porta 8080
echo.

echo Instalando dependencias do Flutter...
flutter pub get

echo.
echo Executando o app Flutter integrado...
echo.
echo 📱 CREDENCIAIS DE TESTE:
echo Email: maria.silva@ubs.gov.br
echo Senha: maria123456
echo.
echo ⚠️  IMPORTANTE: Apenas funcionarios podem fazer login
echo.

flutter run