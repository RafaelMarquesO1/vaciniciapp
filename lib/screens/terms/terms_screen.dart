import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Termos de Uso'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: context.responsivePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdaptiveText(
              'Termos de Uso do Vacinici',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            AdaptiveText(
              'Última atualização: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              '1. Aceitação dos Termos',
              'Ao utilizar o aplicativo Vacinici, você concorda com estes termos de uso. Se não concordar, não utilize o aplicativo.',
            ),
            
            _buildSection(
              context,
              '2. Descrição do Serviço',
              'O Vacinici é um aplicativo de carteira digital de vacinação que permite gerenciar seu histórico de vacinas, agendar imunizações e acompanhar estatísticas de saúde.',
            ),
            
            _buildSection(
              context,
              '3. Dados Pessoais',
              'Coletamos apenas dados necessários para o funcionamento do serviço: nome, CPF, dados de contato e histórico de vacinação. Seus dados são protegidos conforme a LGPD.',
            ),
            
            _buildSection(
              context,
              '4. Responsabilidades do Usuário',
              'Você é responsável por manter suas informações atualizadas e pela veracidade dos dados fornecidos. Não compartilhe suas credenciais de acesso.',
            ),
            
            _buildSection(
              context,
              '5. Limitações de Responsabilidade',
              'O aplicativo é uma ferramenta auxiliar. Sempre consulte profissionais de saúde para orientações médicas. Não nos responsabilizamos por decisões baseadas apenas nas informações do app.',
            ),
            
            _buildSection(
              context,
              '6. Propriedade Intelectual',
              'Todo conteúdo do aplicativo é protegido por direitos autorais. É proibida a reprodução sem autorização.',
            ),
            
            _buildSection(
              context,
              '7. Modificações',
              'Podemos alterar estes termos a qualquer momento. Você será notificado sobre mudanças significativas.',
            ),
            
            _buildSection(
              context,
              '8. Contato',
              'Para dúvidas sobre estes termos, entre em contato através do suporte do aplicativo.',
            ),
            
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AdaptiveText(
                      'Ao continuar usando o aplicativo, você confirma que leu e aceita estes termos.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveText(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          AdaptiveText(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}