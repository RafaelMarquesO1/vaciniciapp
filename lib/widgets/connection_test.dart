import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class ConnectionTest extends StatefulWidget {
  const ConnectionTest({super.key});

  @override
  State<ConnectionTest> createState() => _ConnectionTestState();
}

class _ConnectionTestState extends State<ConnectionTest> {
  String _status = 'Testando conexão...';
  Color _statusColor = Colors.orange;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testando conexão...';
      _statusColor = Colors.orange;
    });

    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/usuarios'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 401) {
        // 401 significa que o servidor está rodando mas precisa de autenticação
        setState(() {
          _status = '✅ Servidor conectado!\nURL: ${ApiService.baseUrl}';
          _statusColor = Colors.green;
        });
      } else {
        setState(() {
          _status = '✅ Servidor respondendo!\nStatus: ${response.statusCode}';
          _statusColor = Colors.green;
        });
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('Connection refused')) {
          _status = '❌ Servidor offline\n\nVerifique se o backend Spring Boot está rodando na porta 8080';
        } else {
          _status = '❌ Erro de conexão\n$e';
        }
        _statusColor = Colors.red;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Status da Conexão',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _statusColor,
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testConnection,
              child: const Text('Testar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}