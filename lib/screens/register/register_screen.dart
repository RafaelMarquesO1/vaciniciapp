import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _acceptTerms = false;
  
  final _cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nome é obrigatório';
    return null;
  }

  String? _validateCPF(String? value) {
    if (value == null || value.isEmpty) return 'CPF é obrigatório';
    String cleanCpf = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanCpf.length != 11) return 'CPF deve ter 11 dígitos';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Senha é obrigatória';
    if (value.length < 6) return 'Senha deve ter pelo menos 6 caracteres';
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.main);
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
          child: ResponsiveBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > AppTheme.mobileBreakpoint;
              
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWideScreen ? 400 : double.infinity,
                  ),
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
                                'Criar Conta', 
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AdaptiveText(
                            'Preencha os dados para criar sua conta',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                            ),
                          ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    hintText: '000.000.000-00',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [_cpfFormatter],
                  validator: _validateCPF,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                                activeColor: primaryColor,
                              ),
                              Expanded(
                                child: AdaptiveText(
                                  'Aceito os termos de uso', 
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, primaryColor.withOpacity(0.8)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Criar Conta',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}