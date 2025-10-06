import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return ApiConfig.baseUrl;
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api'; // Android Emulator
    } else {
      return ApiConfig.baseUrl; // iOS Simulator, Desktop
    }
  }
  
  // Headers padrão
  static Map<String, String> get headers => ApiConfig.defaultHeaders;

  // Headers com autenticação
  static Future<Map<String, String>> get authHeaders async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Login
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.authLogin}'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Salvar token e dados do usuário
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setInt('userId', data['id']);
        await prefs.setString('userEmail', data['email']);
        await prefs.setString('userName', data['nomeCompleto']);
        await prefs.setString('userType', data['tipoUsuario']);
        if (data['cargo'] != null) {
          await prefs.setString('userCargo', data['cargo']);
        }
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Credenciais inválidas';
        
        // Ignorar validação de funcionários do backend
        if (errorMessage.contains('Apenas funcionários podem acessar')) {
          throw Exception('Credenciais inválidas');
        }
        
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('TimeoutException')) {
        throw Exception('Servidor indisponível. Verifique se o backend está rodando.');
      }
      if (e.toString().startsWith('Exception:')) {
        rethrow;
      }
      throw Exception('Erro de conexão: $e');
    }
  }

  // Registro
  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.authRegister}'),
        headers: headers,
        body: jsonEncode(userData),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Falha no registro');
      }
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('TimeoutException')) {
        throw Exception('Servidor indisponível. Verifique se o backend está rodando.');
      }
      throw Exception('Erro de conexão: $e');
    }
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Verificar se está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  // Obter dados do usuário logado
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return null;

    return {
      'id': prefs.getInt('userId'),
      'email': prefs.getString('userEmail'),
      'nomeCompleto': prefs.getString('userName'),
      'tipoUsuario': prefs.getString('userType'),
    };
  }

  // CRUD Usuários
  static Future<List<dynamic>> getUsuarios() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.usuarios}'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar usuários');
      }
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('TimeoutException')) {
        throw Exception('Servidor indisponível. Verifique se o backend está rodando.');
      }
      throw Exception('Erro de conexão: $e');
    }
  }

  static Future<Map<String, dynamic>> getUsuario(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.usuarios}/$id'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar usuário');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  static Future<Map<String, dynamic>> updateUsuario(int id, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl${ApiConfig.usuarios}/$id'),
        headers: await authHeaders,
        body: jsonEncode(userData),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao atualizar usuário');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // CRUD Vacinas
  static Future<List<dynamic>> getVacinas() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.vacinas}'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar vacinas');
      }
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('TimeoutException')) {
        throw Exception('Servidor indisponível. Verifique se o backend está rodando.');
      }
      throw Exception('Erro de conexão: $e');
    }
  }

  static Future<List<dynamic>> getVacinasByCategoria(String categoria) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.vacinas}/categoria/$categoria'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar vacinas por categoria');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // CRUD Histórico de Vacinação
  static Future<List<dynamic>> getHistoricoVacinacao(int pacienteId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.historico}/paciente/$pacienteId'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar histórico de vacinação');
      }
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('TimeoutException')) {
        throw Exception('Servidor indisponível. Verifique se o backend está rodando.');
      }
      throw Exception('Erro de conexão: $e');
    }
  }

  static Future<Map<String, dynamic>> addHistoricoVacinacao(Map<String, dynamic> historicoData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.historico}'),
        headers: await authHeaders,
        body: jsonEncode(historicoData),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao adicionar histórico de vacinação');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Obter locais de vacinação
  static Future<List<dynamic>> getLocaisVacinacao() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.locais}'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar locais de vacinação');
      }
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('TimeoutException')) {
        throw Exception('Servidor indisponível. Verifique se o backend está rodando.');
      }
      throw Exception('Erro de conexão: $e');
    }
  }

  // CRUD Agendamentos
  static Future<List<dynamic>> getAgendamentos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.agendamentos}'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar agendamentos');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  static Future<List<dynamic>> getAgendamentosByPaciente(int pacienteId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiConfig.agendamentos}/paciente/$pacienteId'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar agendamentos do paciente');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  static Future<Map<String, dynamic>> createAgendamento(Map<String, dynamic> agendamentoData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConfig.agendamentos}'),
        headers: await authHeaders,
        body: jsonEncode(agendamentoData),
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao criar agendamento');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar horários disponíveis para um local
  static Future<List<dynamic>> getHorariosDisponiveis(int localId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/locais/$localId/horarios-disponiveis'),
        headers: await authHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar horários disponíveis');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  static Future<void> cancelAgendamento(int agendamentoId, String motivo) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl${ApiConfig.agendamentos}/$agendamentoId/status'),
        headers: await authHeaders,
        body: jsonEncode({
          'status': 'Cancelado',
          'motivoCancelamento': motivo,
        }),
      ).timeout(ApiConfig.requestTimeout);
      if (response.statusCode != 200) {
        throw Exception('Falha ao cancelar agendamento');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}