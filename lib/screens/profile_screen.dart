import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/goal_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
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

                          // Objectives/Goals Section
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
}
