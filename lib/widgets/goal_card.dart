import 'package:flutter/material.dart';
import '../models/goal.dart';

// Couleurs du design épuré
class GoalCardColors {
  static const Color primaryColor = Color(
    0xFFA7C6A5,
  ); // Vert clair pour onglets/boutons
  static const Color lightColor = Color(0xFF85B8CB); // Bleu clair pour fonds
  static const Color darkColor = Color(
    0xFF1F4843,
  ); // Vert foncé pour TOUT le texte
}

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  const GoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: GoalCardColors.darkColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: GoalCardColors.lightColor.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec icône, titre et actions
              Row(
                children: [
                  // Icône de l'objectif
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: GoalCardColors.primaryColor.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      goal.icon,
                      color: GoalCardColors.primaryColor,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Titre et description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                goal.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: GoalCardColors.darkColor,
                                ),
                              ),
                            ),
                            // Badge de statut
                            _buildStatusBadge(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          goal.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: GoalCardColors.darkColor.withValues(
                              alpha: 0.7,
                            ),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Menu d'actions (seulement si des callbacks sont fournis)
                  if (onEdit != null ||
                      onDelete != null ||
                      onToggleStatus != null)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: GoalCardColors.darkColor.withValues(alpha: 0.6),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                          case 'toggle':
                            onToggleStatus?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Modifier'),
                              ],
                            ),
                          ),
                        if (onToggleStatus != null)
                          PopupMenuItem(
                            value: 'toggle',
                            child: Row(
                              children: [
                                Icon(
                                  goal.isActive
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(goal.isActive ? 'Pauser' : 'Activer'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Supprimer',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Barre de progression
              _buildProgressSection(),

              const SizedBox(height: 20),

              // Statistiques
              _buildStatsSection(),

              // Actions rapides (seulement pour les objectifs actifs)
              // if (goal.isActive && onTap != null) ...[
              //   const SizedBox(height: 20),
              //   _buildQuickActions(context),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    if (goal.isCompleted) {
      badgeColor = Colors.green;
      badgeText = 'Complété';
      badgeIcon = Icons.check_circle;
    } else if (goal.isActive) {
      badgeColor = Colors.blue;
      badgeText = 'Actif';
      badgeIcon = Icons.play_circle;
    } else {
      badgeColor = Colors.grey;
      badgeText = 'Archivé';
      badgeIcon = Icons.archive;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 16, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${(goal.progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: GoalCardColors.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: goal.progress,
          minHeight: 8,
          backgroundColor: Colors.grey[300],
          color: GoalCardColors.primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text(
          '${goal.totalDays} jours sur ${goal.targetDays}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Série',
            '${goal.currentStreak}',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem(
            'Meilleure',
            '${goal.maxStreak}',
            Icons.emoji_events,
            Colors.amber,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem(
            'Grade',
            goal.currentGrade.emoji,
            Icons.star,
            goal.currentGrade.color,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
