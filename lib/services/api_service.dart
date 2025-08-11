import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api'; // Android Emulator
    } else {
      return 'http://localhost:8080/api'; // iOS Simulator, Desktop
    }
  }
  
  // Headers padrão
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

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
        Uri.parse('$baseUrl/auth/login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Salvar token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setInt('userId', data['id']);
        await prefs.setString('userEmail', data['email']);
        await prefs.setString('userName', data['nomeCompleto']);
        await prefs.setString('userType', data['tipoUsuario']);
        return data;
      } else {
        throw Exception('Credenciais inválidas');
      }
    } catch (e) {
      if (e.toString().contains('Connection refused') || e.toString().contains('TimeoutException')) {
        throw Exception('Servidor indisponível. Verifique se o backend está rodando.');
      }
      throw Exception('Erro de conexão: $e');
    }
  }

  // Registro
  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: headers,
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha no registro: ${response.body}');
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
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios'),
      headers: await authHeaders,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar usuários');
    }
  }

  static Future<Map<String, dynamic>> getUsuario(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$id'),
      headers: await authHeaders,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar usuário');
    }
  }

  static Future<Map<String, dynamic>> updateUsuario(int id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/usuarios/$id'),
      headers: await authHeaders,
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao atualizar usuário');
    }
  }

  // CRUD Vacinas
  static Future<List<dynamic>> getVacinas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/vacinas'),
      headers: await authHeaders,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar vacinas');
    }
  }

  static Future<List<dynamic>> getVacinasByCategoria(String categoria) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vacinas/categoria/$categoria'),
      headers: await authHeaders,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar vacinas por categoria');
    }
  }

  // CRUD Histórico de Vacinação
  static Future<List<dynamic>> getHistoricoVacinacao(int pacienteId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/historico/paciente/$pacienteId'),
      headers: await authHeaders,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar histórico de vacinação');
    }
  }

  static Future<Map<String, dynamic>> addHistoricoVacinacao(Map<String, dynamic> historicoData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/historico'),
      headers: await authHeaders,
      body: jsonEncode(historicoData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao adicionar histórico de vacinação');
    }
  }
}