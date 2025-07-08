import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  bool _isLoading = false;
  bool _codeSent = false;
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _cpfController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  String? _validateCPF(String? value) {
    if (value == null || value.isEmpty) return 'CPF é obrigatório';
    if (value.length != 11) return 'CPF deve ter 11 dígitos';
    return null;
  }

  String? _validateCode(String? value) {
    if (value == null || value.isEmpty) return 'Código é obrigatório';
    if (value.length != 6) return 'Código deve ter 6 dígitos';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória';
    if (value.length < 8) return 'Senha deve ter pelo menos 8 caracteres';
    return null;
  }

  Future<void> _sendCode() async {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Adicione esta linha
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
      _codeSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Código enviado por SMS'),
        backgroundColor: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [AppTheme.darkBackgroundColor, AppTheme.darkSurfaceColor]
                : [AppTheme.backgroundColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: context.responsivePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AdaptiveText(
                      'Recuperar Senha', 
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: primaryColor,
                ),
                const SizedBox(height: 24),
                AdaptiveText(
                  _codeSent ? 'Digite o código recebido' : 'Digite seu CPF para receber o código',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (!_codeSent) ...[
                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    validator: _validateCPF,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendCode,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Enviar Código'),
                    ),
                  ),
                ] else ...[
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'Código de Verificação',
                      prefixIcon: Icon(Icons.sms_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: _validateCode,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Nova Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Alterar Senha'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _codeSent = false),
                    child: const Text('Não recebi o código'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}