import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vaciniciapp/models/historico_vacinas.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';

class VaccineDetailScreen extends StatelessWidget {
  const VaccineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaccine = ModalRoute.of(context)!.settings.arguments as HistoricoVacina;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar personalizada (Revisada)
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                vaccine.nomeVacina,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.vaccines,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          // Conteúdo principal
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Card principal com informações da vacina
                AdaptiveCard(
                  margin: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header do card
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColorLight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.verified_user,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AdaptiveText(
                                  'COMPROVANTE DE VACINAÇÃO',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AdaptiveText(
                                  vaccine.dose,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      if (vaccine.descricaoVacina != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            vaccine.descricaoVacina!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Informações detalhadas da vacina
                AdaptiveText(
                  'Informações da Aplicação',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Grid de informações da vacina (decidindo)
                _InfoCard(
                  icon: Icons.calendar_today,
                  title: 'Data de Aplicação',
                  value: DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR').format(vaccine.dataAplicacao),
                ),
                
                const SizedBox(height: 12),
                
                _InfoCard(
                  icon: Icons.person_outline,
                  title: 'Aplicada por',
                  value: vaccine.nomeAplicador ?? 'Não informado',
                ),
                
                const SizedBox(height: 12),
                
                _InfoCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Lote',
                  value: vaccine.lote,
                  copyable: true,
                ),
                
                const SizedBox(height: 12),
                
                _InfoCard(
                  icon: Icons.local_hospital_outlined,
                  title: 'Unidade de Saúde',
                  value: 'UBS - Edini Cavalcante Consol',
                ),
                
                const SizedBox(height: 32),
                
                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareVaccine(context, vaccine),
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Compartilhar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(color: AppTheme.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _downloadVaccine(context, vaccine),
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Baixar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _shareVaccine(BuildContext context, HistoricoVacina vaccine) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Compartilhar Comprovante',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShareOption(
                  icon: Icons.message,
                  label: 'WhatsApp',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _shareToApp(context, vaccine, 'WhatsApp');
                  },
                ),
                _ShareOption(
                  icon: Icons.email,
                  label: 'E-mail',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _shareToApp(context, vaccine, 'E-mail');
                  },
                ),
                _ShareOption(
                  icon: Icons.copy,
                  label: 'Copiar',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _copyToClipboard(context, vaccine);
                  },
                ),
                _ShareOption(
                  icon: Icons.more_horiz,
                  label: 'Mais',
                  color: Colors.grey,
                  onTap: () {
                    Navigator.pop(context);
                    _shareToApp(context, vaccine, 'Sistema');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _shareToApp(BuildContext context, HistoricoVacina vaccine, String app) {
    final text = '''🩹 COMPROVANTE DE VACINAÇÃO

💉 Vacina: ${vaccine.nomeVacina}
📅 Data: ${DateFormat('dd/MM/yyyy', 'pt_BR').format(vaccine.dataAplicacao)}
💊 Dose: ${vaccine.dose}
🏥 Lote: ${vaccine.lote}
👨‍⚕️ Aplicador: ${vaccine.nomeAplicador ?? 'Não informado'}

📱 VaciniciApp - Sua carteira digital''';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.share, color: Colors.white),
            const SizedBox(width: 8),
            Text('Compartilhando via $app...'),
          ],
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppTheme.darkPrimaryColor 
            : AppTheme.primaryColor,
      ),
    );
  }

  void _copyToClipboard(BuildContext context, HistoricoVacina vaccine) {
    final text = '''🩹 COMPROVANTE DE VACINAÇÃO

💉 Vacina: ${vaccine.nomeVacina}
📅 Data: ${DateFormat('dd/MM/yyyy', 'pt_BR').format(vaccine.dataAplicacao)}
💊 Dose: ${vaccine.dose}
🏥 Lote: ${vaccine.lote}
👨‍⚕️ Aplicador: ${vaccine.nomeAplicador ?? 'Não informado'}

📱 VaciniciApp - Sua carteira digital''';
    
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Comprovante copiado!'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadVaccine(BuildContext context, HistoricoVacina vaccine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.download_rounded),
            SizedBox(width: 8),
            Text('Download'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('PDF'),
              subtitle: const Text('Comprovante em formato PDF'),
              onTap: () {
                Navigator.pop(context);
                _simulateDownload(context, 'PDF');
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.blue),
              title: const Text('Imagem'),
              subtitle: const Text('Comprovante como imagem'),
              onTap: () {
                Navigator.pop(context);
                _simulateDownload(context, 'Imagem');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _simulateDownload(BuildContext context, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text('Baixando $format...'),
          ],
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppTheme.darkPrimaryColor 
            : AppTheme.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('$format salvo na pasta Downloads!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool copyable;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.copyable = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;
    
    return AdaptiveCard(
      margin: EdgeInsets.zero,
      showBorder: true,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColorLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdaptiveText(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                AdaptiveText(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (copyable)
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Copiado para a área de transferência'),
                    backgroundColor: primaryColor,
                  ),
                );
              },
              icon: const Icon(
                Icons.copy_outlined,
                size: 18,
                color: AppTheme.textColorSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}