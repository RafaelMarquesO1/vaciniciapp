class ApiConfig {
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Endpoints
  static const String authLogin = '/auth/mobile-login';
  static const String authRegister = '/auth/register';
  static const String usuarios = '/usuarios';
  static const String vacinas = '/vacinas';
  static const String locais = '/locais';
  static const String historico = '/historico';
  static const String agendamentos = '/agendamentos';
  
  // Headers padrão
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout para requisições
  static const Duration requestTimeout = Duration(seconds: 30);
}