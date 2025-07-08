# 💉 VaciniciApp

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.32.5-blue?logo=flutter" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Dart-3.0+-blue?logo=dart" alt="Dart Version">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
</div>

## 📱 Sobre o Projeto

O **VaciniciApp** é uma carteira digital de vacinação moderna e acessível, desenvolvida em Flutter. O aplicativo permite que usuários gerenciem seu histórico de vacinas, agendem imunizações e acompanhem estatísticas de saúde de forma prática e segura.

### ✨ Principais Funcionalidades

- 🏠 **Dashboard Intuitivo** - Interface limpa com ações rápidas
- 💉 **Carteira Digital** - Histórico completo de vacinas aplicadas
- 📅 **Agendamento** - Sistema de marcação de consultas
- 📊 **Estatísticas** - Acompanhamento da cobertura vacinal
- 👤 **Perfil Completo** - Gerenciamento de dados pessoais
- 🌙 **Tema Escuro** - Interface adaptativa para melhor experiência
- 📱 **Design Responsivo** - Otimizado para todos os dispositivos

## 🎨 Design System

### Tema Claro
- **Primária**: `#2E7D32` (Verde Saúde)
- **Secundária**: `#4CAF50` (Verde Claro)
- **Background**: `#F8F9FA` (Cinza Muito Claro)

### Tema Escuro
- **Primária**: `#4CAF50` (Verde Claro)
- **Background**: `#121212` (Preto Material)
- **Surface**: `#1E1E1E` (Cinza Escuro)

## 🚀 Tecnologias Utilizadas

- **Flutter 3.32.5** - Framework multiplataforma
- **Dart 3.0+** - Linguagem de programação
- **Provider** - Gerenciamento de estado
- **SharedPreferences** - Persistência local
- **Material Design 3** - Sistema de design

## 📦 Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  shared_preferences: ^2.2.3
  intl: ^0.19.0
  mask_text_input_formatter: ^2.9.0
```

## 🛠️ Instalação e Execução

### Pré-requisitos
- Flutter SDK 3.32.5 ou superior
- Dart 3.0 ou superior
- Android Studio / VS Code
- Emulador Android ou dispositivo físico

### Passos para Execução

1. **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/vaciniciapp.git
cd vaciniciapp
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o aplicativo**
```bash
flutter run
```

### Scripts Auxiliares

- **Windows**: Execute `test_app.bat` para limpeza e execução automática
- **Desenvolvimento**: Use `flutter run --debug` para modo debug
- **Release**: Use `flutter build apk` para gerar APK

## 📱 Funcionalidades Detalhadas

### 🏠 Tela Principal
- Ícone animado da vacina com rotação e pulsação
- Barra de pesquisa com gradiente adaptativo
- Grid responsivo de ações rápidas
- Lista horizontal de profissionais de saúde

### 💉 Carteira de Vacinação
- Header personalizado com informações do usuário
- Filtros modernos (Todas, Recentes, Antigas)
- Cards animados para cada vacina
- FAB para download em PDF
- Estado vazio com design atrativo

### 📅 Sistema de Agendamento
- Seleção de tipo de vacina com cards visuais
- Escolha de local com informações de distância
- Seletores de data e hora adaptativos
- Confirmação com feedback visual

### ⚙️ Configurações
- Toggle de tema claro/escuro
- Seções organizadas com ícones
- Cards modernos com bordas e sombras
- Persistência de preferências

## 🎯 Arquitetura do Projeto

```
lib/
├── data/           # Dados mockados e modelos
├── routes/         # Configuração de rotas
├── screens/        # Telas do aplicativo
├── theme/          # Sistema de temas
├── widgets/        # Componentes reutilizáveis
└── main.dart       # Ponto de entrada
```

### Componentes Reutilizáveis

- **AdaptiveCard** - Cards que se adaptam ao tema
- **GradientCard** - Cards com gradientes dinâmicos
- **ResponsiveWidget** - Layouts responsivos
- **ThemeToggleButton** - Botão de alternância de tema
- **AnimatedFab** - FAB com animações

## 🌟 Destaques Técnicos

### Performance
- Widgets `const` para otimização
- Animações suaves (150-300ms)
- Rebuilds mínimos com Provider
- Lazy loading em listas

### Responsividade
- Breakpoints definidos (mobile: 600px, tablet: 1024px)
- Layouts adaptativos que se reorganizam
- Textos e ícones escaláveis
- Grid responsivo com aspect ratio dinâmico

### Acessibilidade
- Suporte completo ao tema escuro
- Contraste otimizado para legibilidade
- Hierarquia visual clara
- Feedback tátil e visual

## 🧪 Testes

Para executar os testes:

```bash
flutter test
```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Contribuição

Contribuições são bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📞 Contato

- **Desenvolvedor**: Seu Nome
- **Email**: seu.email@exemplo.com
- **LinkedIn**: [Seu LinkedIn](https://linkedin.com/in/seu-perfil)

---

<div align="center">
  <p>Desenvolvido com ❤️ e Flutter</p>
  <p>© 2024 VaciniciApp. Todos os direitos reservados.</p>
</div>