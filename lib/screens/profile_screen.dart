import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../services/goal_service.dart';
import '../models/goal.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Modern Header with Username and Aura Level
                SliverAppBar(
                  expandedHeight: isTablet ? 320.0 : 280.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF6366F1),
                            const Color(0xFF8B5CF6),
                            const Color(0xFFA855F7),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          isTablet ? 80.0 : 60.0,
                          padding,
                          padding,
                        ),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Profile Avatar
                              Container(
                                padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 40.0 : 36.0,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: isTablet ? 48.0 : 40.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: isTablet ? 24.0 : 20.0),

                              // Username Display
                              Consumer<UserProfileService>(
                                builder: (context, profileService, child) {
                                  final profile = profileService.userProfile;
                                  if (profile == null)
                                    return const SizedBox.shrink();

                                  return Text(
                                    profile.username,
                                    style: TextStyle(
                                      fontSize: isTablet ? 36.0 : 32.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: isTablet ? 16.0 : 12.0),

                              // Aura Level Progress
                              Consumer<UserProfileService>(
                                builder: (context, profileService, child) {
                                  final auraStats = profileService
                                      .getAuraStats();
                                  if (auraStats.isEmpty)
                                    return const SizedBox.shrink();

                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(
                                      isTablet ? 20.0 : 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Niveau ${auraStats['currentLevel']}',
                                              style: TextStyle(
                                                fontSize: isTablet
                                                    ? 18.0
                                                    : 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              '${(auraStats['progressToNext'] * 100).round()}%',
                                              style: TextStyle(
                                                fontSize: isTablet
                                                    ? 18.0
                                                    : 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isTablet ? 12.0 : 8.0),
                                        LinearProgressIndicator(
                                          value: auraStats['progressToNext'],
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.3),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                          minHeight: isTablet ? 8.0 : 6.0,
                                        ),
                                        SizedBox(height: isTablet ? 8.0 : 6.0),
                                        Text(
                                          auraStats['levelName'],
                                          style: TextStyle(
                                            fontSize: isTablet ? 16.0 : 14.0,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.only(right: padding, top: padding),
                      child: IconButton(
                        onPressed: () => _showProfileSettings(context),
                        icon: Container(
                          padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: isTablet ? 24.0 : 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        children: [
                          // User Grade/Rank Section
                          _buildGradeSection(isTablet),

                          SizedBox(height: isTablet ? 32.0 : 24.0),

                          // Global Stats Section
                          _buildGlobalStatsSection(isTablet),

                          SizedBox(height: isTablet ? 32.0 : 24.0),

                          // Objectives/Goals Section
                          _buildGoalsSection(isTablet),

                          SizedBox(height: isTablet ? 32.0 : 24.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradeSection(bool isTablet) {
    return Consumer<GoalService>(
      builder: (context, goalService, child) {
        final highestGrade = goalService.highestGradeAchieved;

        return Container(
          padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                    decoration: BoxDecoration(
                      color: highestGrade.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      highestGrade.emoji,
                      style: TextStyle(fontSize: isTablet ? 32.0 : 28.0),
                    ),
                  ),
                  SizedBox(width: isTablet ? 20.0 : 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grade Actuel',
                          style: TextStyle(
                            fontSize: isTablet ? 16.0 : 14.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          highestGrade.title,
                          style: TextStyle(
                            fontSize: isTablet ? 24.0 : 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 20.0 : 16.0),

              // Progress to next grade
              Consumer<GoalService>(
                builder: (context, goalService, child) {
                  final goals = goalService.goals;
                  if (goals.isEmpty) return const SizedBox.shrink();

                  final totalDays = goalService.totalDaysAcrossAllGoals;
                  final nextGrade = highestGrade.nextGrade;

                  if (nextGrade == null) {
                    return Container(
                      padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Grade maximum atteint !',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final progress =
                      (totalDays - highestGrade.minDays) /
                      (nextGrade.minDays - highestGrade.minDays);
                  final progressPercent = (progress * 100).clamp(0.0, 100.0);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prochain grade: ${nextGrade.title}',
                            style: TextStyle(
                              fontSize: isTablet ? 16.0 : 14.0,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${progressPercent.round()}%',
                            style: TextStyle(
                              fontSize: isTablet ? 16.0 : 14.0,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          highestGrade.color,
                        ),
                        minHeight: 8,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$totalDays jours / ${nextGrade.minDays} jours requis',
                        style: TextStyle(
                          fontSize: isTablet ? 14.0 : 12.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlobalStatsSection(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Statistiques Globales',
            style: TextStyle(
              fontSize: isTablet ? 24.0 : 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: isTablet ? 24.0 : 20.0),

          Consumer2<UserProfileService, GoalService>(
            builder: (context, profileService, goalService, child) {
              final auraStats = profileService.getAuraStats();
              final totalGoals = goalService.totalCompletedGoals;
              final totalDays = goalService.totalDaysAcrossAllGoals;
              final bestStreak = goalService.bestStreakEver;

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isTablet ? 3 : 2,
                crossAxisSpacing: isTablet ? 20.0 : 16.0,
                mainAxisSpacing: isTablet ? 20.0 : 16.0,
                childAspectRatio: isTablet ? 1.2 : 1.1,
                children: [
                  _buildStatCard(
                    'Victoires',
                    '$totalGoals',
                    Icons.emoji_events,
                    Colors.amber,
                    isTablet,
                  ),
                  _buildStatCard(
                    'Jours Total',
                    '$totalDays',
                    Icons.calendar_today,
                    Colors.blue,
                    isTablet,
                  ),
                  _buildStatCard(
                    'Meilleur Streak',
                    '$bestStreak',
                    Icons.local_fire_department,
                    Colors.orange,
                    isTablet,
                  ),
                  _buildStatCard(
                    'Badges',
                    '${auraStats['badgesCount'] ?? 0}',
                    Icons.workspace_premium,
                    Colors.purple,
                    isTablet,
                  ),
                  _buildStatCard(
                    'Jours Consécutifs',
                    '${auraStats['consecutiveDays'] ?? 0}',
                    Icons.trending_up,
                    Colors.green,
                    isTablet,
                  ),
                  _buildStatCard(
                    'Niveau Aura',
                    '${auraStats['currentLevel'] ?? 1}',
                    Icons.auto_awesome,
                    Colors.indigo,
                    isTablet,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: isTablet ? 32.0 : 28.0),
          ),
          SizedBox(height: isTablet ? 16.0 : 12.0),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 24.0 : 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 14.0 : 12.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 Objectifs & Progrès',
            style: TextStyle(
              fontSize: isTablet ? 24.0 : 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: isTablet ? 24.0 : 20.0),

          Consumer<GoalService>(
            builder: (context, goalService, child) {
              final goals = goalService.goals;
              final activeGoal = goalService.activeGoal;

              if (goals.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_task,
                        size: isTablet ? 48.0 : 40.0,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucun objectif défini',
                        style: TextStyle(
                          fontSize: isTablet ? 18.0 : 16.0,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Commencez par créer votre premier objectif !',
                        style: TextStyle(
                          fontSize: isTablet ? 14.0 : 12.0,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final completedGoals = goalService.completedGoals;
              return Column(
                children: [
                  // Active Goal
                  if (activeGoal != null) ...[
                    _buildGoalCard(activeGoal, true, isTablet),
                    SizedBox(height: isTablet ? 20.0 : 16.0),
                  ],

                  // Completed Goals
                  if (completedGoals.isNotEmpty) ...[
                    Text(
                      'Objectifs Complétés',
                      style: TextStyle(
                        fontSize: isTablet ? 18.0 : 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: isTablet ? 16.0 : 12.0),
                    ...completedGoals
                        .take(3)
                        .map((goal) => _buildGoalCard(goal, false, isTablet))
                        .toList(),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(Goal goal, bool isActive, bool isTablet) {
    final progress = goal.progress;
    final progressPercent = (progress * 100).round();

    return Container(
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withValues(alpha: 0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? Colors.blue.withValues(alpha: 0.3)
              : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
                decoration: BoxDecoration(
                  color: goal.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  goal.icon,
                  color: goal.color,
                  size: isTablet ? 24.0 : 20.0,
                ),
              ),
              SizedBox(width: isTablet ? 16.0 : 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: TextStyle(
                        fontSize: isTablet ? 18.0 : 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: TextStyle(
                        fontSize: isTablet ? 14.0 : 12.0,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12.0 : 8.0,
                    vertical: isTablet ? 6.0 : 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Actif',
                    style: TextStyle(
                      fontSize: isTablet ? 12.0 : 10.0,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: isTablet ? 16.0 : 12.0),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progression',
                    style: TextStyle(
                      fontSize: isTablet ? 14.0 : 12.0,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$progressPercent%',
                    style: TextStyle(
                      fontSize: isTablet ? 14.0 : 12.0,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(goal.color),
                minHeight: 8,
              ),
              SizedBox(height: 8),
              Text(
                '${goal.totalDays} / ${goal.targetDays} jours',
                style: TextStyle(
                  fontSize: isTablet ? 12.0 : 10.0,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),

          // Goal Stats
          SizedBox(height: isTablet ? 16.0 : 12.0),
          Row(
            children: [
              _buildGoalStat(
                'Streak',
                '${goal.currentStreak}',
                Icons.local_fire_department,
                Colors.orange,
                isTablet,
              ),
              SizedBox(width: isTablet ? 20.0 : 16.0),
              _buildGoalStat(
                'Meilleur',
                '${goal.maxStreak}',
                Icons.trending_up,
                Colors.green,
                isTablet,
              ),
              SizedBox(width: isTablet ? 20.0 : 16.0),
              _buildGoalStat(
                'Grade',
                goal.currentGrade.title,
                Icons.star,
                goal.currentGrade.color,
                isTablet,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalStat(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isTablet ? 12.0 : 8.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: isTablet ? 20.0 : 16.0),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isTablet ? 12.0 : 10.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 10.0 : 8.0,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '⚙️ Paramètres du Profil',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Options de configuration du profil utilisateur',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fermer',
              style: TextStyle(
                color: const Color(0xFF6366F1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
