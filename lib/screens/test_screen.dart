import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/goal_service.dart';
import '../services/calendar_service.dart';
import '../services/user_profile_service.dart';
import '../services/badge_sync_service.dart';
import '../models/goal.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _auraPointsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _goalNameController.text = 'Test Objectif';
    _daysController.text = '30';
    _auraPointsController.text = '100';
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    _daysController.dispose();
    _auraPointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🧪 Zone de Test',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTestSection('🎯 Test des Objectifs', [
              _buildTestCard(
                'Créer un objectif de test',
                'Crée un objectif avec le nom et nombre de jours spécifiés',
                Icons.flag,
                Colors.blue,
                () => _createTestGoal(context),
              ),
              _buildTestCard(
                'Compléter 30 jours',
                'Marque 30 sessions comme complétées pour tester les badges',
                Icons.check_circle,
                Colors.green,
                () => _complete30Days(context),
              ),
              _buildTestCard(
                'Reset tous les objectifs',
                'Supprime tous les objectifs existants',
                Icons.refresh,
                Colors.red,
                () => _resetAllGoals(context),
              ),
            ]),
            const SizedBox(height: 32),
            _buildTestSection('📅 Test des Calendriers', [
              _buildTestCard(
                'Générer nouvelle forme',
                'Crée une nouvelle forme de calendrier aléatoire',
                Icons.shuffle,
                Colors.purple,
                () => _generateNewCalendarShape(context),
              ),
              _buildTestCard(
                'Débloquer tous les badges',
                'Débloque tous les badges de calendrier',
                Icons.emoji_events,
                Colors.amber,
                () => _unlockAllCalendarBadges(context),
              ),
              _buildTestCard(
                'Reset progression calendrier',
                'Remet à zéro la progression des calendriers',
                Icons.restore,
                Colors.orange,
                () => _resetCalendarProgress(context),
              ),
            ]),
            const SizedBox(height: 32),
            _buildTestSection('✨ Test de l\'Aura', [
              _buildTestCard(
                'Ajouter des points d\'aura',
                'Ajoute des points d\'aura au profil utilisateur',
                Icons.auto_awesome,
                Colors.indigo,
                () => _addAuraPoints(context),
              ),
              _buildTestCard(
                'Simuler un jour manqué',
                'Simule un jour manqué pour tester la perte d\'aura',
                Icons.cancel,
                Colors.red,
                () => _simulateMissedDay(context),
              ),
              _buildTestCard(
                'Reset profil utilisateur',
                'Remet à zéro le profil et l\'aura',
                Icons.person_off,
                Colors.grey,
                () => _resetUserProfile(context),
              ),
            ]),
            const SizedBox(height: 32),
            _buildTestSection('🔧 Tests Avancés', [
              _buildTestCard(
                'Test complet 30 jours',
                'Exécute un test complet de 30 jours avec tous les systèmes',
                Icons.play_arrow,
                Colors.teal,
                () => _runComplete30DayTest(context),
              ),
              _buildTestCard(
                'Vérifier synchronisation',
                'Vérifie la synchronisation entre tous les services',
                Icons.sync,
                Colors.cyan,
                () => _checkSynchronization(context),
              ),
            ]),
            const SizedBox(height: 32),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTestCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚙️ Paramètres de Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _goalNameController,
              decoration: const InputDecoration(
                labelText: 'Nom de l\'objectif de test',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _daysController,
              decoration: const InputDecoration(
                labelText: 'Nombre de jours',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _auraPointsController,
              decoration: const InputDecoration(
                labelText: 'Points d\'aura à ajouter',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  // Test des Objectifs
  void _createTestGoal(BuildContext context) {
    final goalService = context.read<GoalService>();
    final title = _goalNameController.text;
    final days = int.tryParse(_daysController.text) ?? 30;

    final goal = Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: 'Objectif de test créé automatiquement',
      targetDays: days,
      color: Colors
          .primaries[DateTime.now().millisecond % Colors.primaries.length],
      icon: Icons.flag,
      createdAt: DateTime.now(),
    );

    goalService.addGoal(goal);
    goalService.activateGoal(goal.id);

    _showSuccessMessage(context, 'Objectif de test créé et activé !');
  }

  void _complete30Days(BuildContext context) {
    final goalService = context.read<GoalService>();
    final profileService = context.read<UserProfileService>();
    final activeGoal = goalService.activeGoal;

    if (activeGoal == null) {
      _showErrorMessage(context, 'Aucun objectif actif trouvé');
      return;
    }

    // Compléter 30 jours
    for (int i = 0; i < 30; i++) {
      goalService.updateProgress(activeGoal.id);
      goalService.updateAura(profileService);
    }

    _showSuccessMessage(context, '30 jours complétés ! Objectif terminé !');
  }

  void _resetAllGoals(BuildContext context) {
    final goalService = context.read<GoalService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer tous les objectifs ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Supprimer tous les objectifs
              final goalIds = List<String>.from(
                goalService.goals.map((g) => g.id),
              );
              for (final id in goalIds) {
                goalService.deleteGoal(id);
              }
              Navigator.pop(context);
              _showSuccessMessage(
                context,
                'Tous les objectifs ont été supprimés',
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  // Test des Calendriers
  void _generateNewCalendarShape(BuildContext context) {
    final calendarService = context.read<CalendarService>();
    calendarService.generateNewShape();
    _showSuccessMessage(context, 'Nouvelle forme de calendrier générée !');
  }

  void _unlockAllCalendarBadges(BuildContext context) {
    final calendarService = context.read<CalendarService>();
    final shapes = calendarService.shapes;

    for (final shape in shapes) {
      if (!shape.isUnlocked) {
        calendarService.unlockBadge(shape);
      }
    }

    _showSuccessMessage(context, 'Tous les badges de calendrier débloqués !');
  }

  void _resetCalendarProgress(BuildContext context) {
    final calendarService = context.read<CalendarService>();
    calendarService.resetProgress();
    _showSuccessMessage(context, 'Progression des calendriers remise à zéro !');
  }

  // Test de l'Aura
  void _addAuraPoints(BuildContext context) {
    final profileService = context.read<UserProfileService>();
    final points = int.tryParse(_auraPointsController.text) ?? 100;

    // Ajouter des points d'aura en simulant des jours complétés
    for (int i = 0; i < points; i++) {
      profileService.addAuraForDay();
    }

    _showSuccessMessage(context, '$points points d\'aura ajoutés !');
  }

  void _simulateMissedDay(BuildContext context) {
    final profileService = context.read<UserProfileService>();
    profileService.simulateMissedDay();
    _showSuccessMessage(context, 'Jour manqué simulé ! Aura perdue !');
  }

  void _resetUserProfile(BuildContext context) {
    final profileService = context.read<UserProfileService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
          'Êtes-vous sûr de vouloir remettre à zéro le profil utilisateur ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              profileService.resetProfile();
              Navigator.pop(context);
              _showSuccessMessage(context, 'Profil utilisateur remis à zéro !');
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  // Tests Avancés
  void _runComplete30DayTest(BuildContext context) {
    final goalService = context.read<GoalService>();
    final profileService = context.read<UserProfileService>();

    // Créer un objectif de test
    final testGoal = Goal(
      id: 'test_30_days',
      title: 'Test 30 Jours Complet',
      description: 'Test automatique de 30 jours',
      targetDays: 30,
      color: Colors.teal,
      icon: Icons.science,
      createdAt: DateTime.now(),
    );

    goalService.addGoal(testGoal);
    goalService.activateGoal(testGoal.id);

    // Compléter 30 jours
    for (int i = 0; i < 30; i++) {
      goalService.updateProgress(testGoal.id);
      goalService.updateAura(profileService);
    }

    // Vérifier les badges
    BadgeSyncService.checkAndUnlockBadges(context);

    _showSuccessMessage(
      context,
      'Test 30 jours complet exécuté ! Vérifiez les badges et l\'aura !',
    );
  }

  void _checkSynchronization(BuildContext context) {
    final goalService = context.read<GoalService>();
    final profileService = context.read<UserProfileService>();
    final calendarService = context.read<CalendarService>();

    final stats = {
      'Objectifs': goalService.goals.length,
      'Objectif actif': goalService.activeGoal?.title ?? 'Aucun',
      'Formes de calendrier': calendarService.shapes.length,
      'Badges débloqués': calendarService.unlockedBadges.length,
      'Niveau d\'aura': profileService.userProfile?.auraLevel ?? 0,
      'Points d\'aura': profileService.userProfile?.auraPoints ?? 0,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('État de Synchronisation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: stats.entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${entry.key}: ${entry.value}'),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
