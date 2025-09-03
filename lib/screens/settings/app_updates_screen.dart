import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppUpdatesScreen extends StatefulWidget {
  const AppUpdatesScreen({super.key});

  @override
  State<AppUpdatesScreen> createState() => _AppUpdatesScreenState();
}

class _AppUpdatesScreenState extends State<AppUpdatesScreen>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;

  final List<UpdateItem> _updateHistory = [
    UpdateItem(
      version: '2.1.0',
      date: '15 janvier 2024',
      description: 'Nouvelle interface utilisateur, amélioration des performances',
      isInstalled: true,
      features: [
        'Interface redesignée',
        'Performance améliorée de 40%',
        'Nouveaux badges exclusifs',
        'Correction de bugs mineurs'
      ],
    ),
    UpdateItem(
      version: '2.0.5',
      date: '28 décembre 2023',
      description: 'Corrections de bugs et optimisations',
      isInstalled: true,
      features: [
        'Correction du crash au démarrage',
        'Amélioration de la synchronisation',
        'Optimisation de la batterie'
      ],
    ),
    UpdateItem(
      version: '2.0.0',
      date: '10 décembre 2023',
      description: 'Mise à jour majeure avec de nouvelles fonctionnalités',
      isInstalled: true,
      features: [
        'Système de niveaux et XP',
        'Calendrier interactif',
        'Statistiques avancées',
        'Mode sombre'
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mises à jour',
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              _buildUpcomingFeaturesSection(),
              const SizedBox(height: 24),
              _buildUpdateHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingFeaturesSection() {
    return _buildSection(
      title: 'Prochaines Fonctionnalités',
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'À venir dans v2.2.0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem('🔄', 'Synchronisation multi-appareils'),
              _buildFeatureItem('👥', 'Défis entre amis'),
              _buildFeatureItem('📊', 'Rapports hebdomadaires détaillés'),
              _buildFeatureItem('🎨', 'Thèmes personnalisables'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateHistorySection() {
    return _buildSection(
      title: 'Historique des Mises à jour',
      children: [
        for (int i = 0; i < _updateHistory.length; i++) ...[
          _buildUpdateHistoryItem(_updateHistory[i]),
          if (i != _updateHistory.length - 1)
            Divider(height: 1, color: Colors.grey.shade200),
        ],
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }


  Widget _buildFeatureItem(String emoji, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateHistoryItem(UpdateItem update) {
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: update.isInstalled 
              ? Colors.green.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          update.isInstalled ? Icons.check_circle : Icons.download,
          color: update.isInstalled ? Colors.green : Colors.grey,
        ),
      ),
      title: Text(
        'Version ${update.version}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            update.date,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            update.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nouveautés :',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              ...update.features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }


}

class UpdateItem {
  final String version;
  final String date;
  final String description;
  final bool isInstalled;
  final List<String> features;

  UpdateItem({
    required this.version,
    required this.date,
    required this.description,
    required this.isInstalled,
    required this.features,
  });
}
