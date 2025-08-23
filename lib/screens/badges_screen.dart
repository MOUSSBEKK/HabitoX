import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/calendar_service.dart';
import '../services/user_profile_service.dart';
import '../widgets/aura_badges_widget.dart';
import '../widgets/badges_widget.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;
        final headerPadding = isTablet ? 80.0 : 60.0;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.amber.withOpacity(0.1),
                  Colors.orange.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header avec design premium
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      padding,
                      headerPadding,
                      padding,
                      padding,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.amber.withOpacity(0.2),
                          Colors.orange.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 24.0 : 20.0,
                                ),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.emoji_events,
                                size: isTablet ? 40.0 : 32.0,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(width: isTablet ? 20.0 : 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🏆 Collection de Badges',
                                    style: TextStyle(
                                      fontSize: isTablet ? 32.0 : 28.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Débloquez des récompenses en progressant',
                                    style: TextStyle(
                                      fontSize: isTablet ? 18.0 : 16.0,
                                      color: Colors.amber.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 24.0 : 20.0),

                        // Statistiques des badges
                        Consumer2<CalendarService, UserProfileService>(
                          builder:
                              (
                                context,
                                calendarService,
                                profileService,
                                child,
                              ) {
                                final totalCalendarBadges =
                                    calendarService.unlockedBadges.length;
                                final totalAuraBadges =
                                    profileService.unlockedBadges.length;
                                final totalBadges =
                                    totalCalendarBadges + totalAuraBadges;

                                return Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        'Total Badges',
                                        '$totalBadges',
                                        Icons.emoji_events,
                                        Colors.amber,
                                        isTablet,
                                      ),
                                    ),
                                    SizedBox(width: isTablet ? 20.0 : 16.0),
                                    Expanded(
                                      child: _buildStatCard(
                                        'Calendrier',
                                        '$totalCalendarBadges',
                                        Icons.calendar_month,
                                        Colors.purple,
                                        isTablet,
                                      ),
                                    ),
                                    SizedBox(width: isTablet ? 20.0 : 16.0),
                                    Expanded(
                                      child: _buildStatCard(
                                        'Aura',
                                        '$totalAuraBadges',
                                        Icons.auto_awesome,
                                        Colors.indigo,
                                        isTablet,
                                      ),
                                    ),
                                  ],
                                );
                              },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 24.0 : 20.0),

                  // Onglets stylisés
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        isTablet ? 20.0 : 16.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.amber,
                      unselectedLabelColor: Colors.grey[600],
                      indicatorColor: Colors.amber,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 18.0 : 16.0,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 18.0 : 16.0,
                      ),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.calendar_month),
                          text: 'Calendrier',
                        ),
                        Tab(icon: Icon(Icons.auto_awesome), text: 'Aura'),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 24.0 : 20.0),

                  // Contenu des onglets
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Onglet Badges Calendrier
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: padding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 28.0 : 24.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const BadgesWidget(),
                        ),

                        // Onglet Badges Aura
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: padding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 28.0 : 24.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const AuraBadgesWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isTablet ? 20.0 : 16.0),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isTablet ? 28.0 : 24.0),
          SizedBox(height: isTablet ? 10.0 : 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 24.0 : 20.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isTablet ? 6.0 : 4.0),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 14.0 : 12.0,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
