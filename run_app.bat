@echo off
echo Limpando projeto...
flutter clean
echo Baixando dependencias...
flutter pub get
echo Executando aplicativo...
flutter run
pause