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

  final List<UpdateItem> _updateHistory = [];

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
      appBar: AppBar(title: const Text('Mises à jour')),
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
                'À venir dans v1.0.1',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem('Import & Export des données'),
              _buildFeatureItem('Ajout de phrase de motivation'),
              _buildFeatureItem('Ajout de widget sur l\'écran d\'accueil'),
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

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
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
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(child: Text(feature, style: const TextStyle(fontSize: 14))),
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
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          update.isInstalled ? Icons.check_circle : Icons.download,
          color: update.isInstalled
              ? Theme.of(context).colorScheme.secondary
              : Colors.grey,
        ),
      ),
      title: Text(
        'Version ${update.version}',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            update.date,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            update.description,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
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
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ...update.features.map(
                (feature) => Padding(
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
                ),
              ),
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
