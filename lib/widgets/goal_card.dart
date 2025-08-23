import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: goal.color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: goal.color.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec icône, titre et actions
              Row(
                children: [
                  // Icône de l'objectif
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: goal.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(goal.icon, color: goal.color, size: 28),
                  ),

                  const SizedBox(width: 16),

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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Badge de statut
                            _buildStatusBadge(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goal.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Menu d'actions
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                        case 'toggle':
                          onToggleStatus();
                          break;
                      }
                    },
                    itemBuilder: (context) => _buildPopupMenuItems(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Grade actuel
              _buildGradeSection(),

              const SizedBox(height: 20),

              // Barre de progression
              _buildProgressSection(),

              const SizedBox(height: 16),

              // Statistiques
              _buildStatsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String statusText;
    IconData statusIcon;

    if (goal.isCompleted) {
      badgeColor = Colors.green;
      statusText = 'Complété';
      statusIcon = Icons.check_circle;
    } else if (goal.isActive) {
      badgeColor = Colors.blue;
      statusText = 'Actif';
      statusIcon = Icons.play_circle;
    } else {
      badgeColor = Colors.grey;
      statusText = 'Archivé';
      statusIcon = Icons.pause_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSection() {
    final currentGrade = goal.currentGrade;
    final nextGrade = goal.nextGrade;

    return Row(
      children: [
        Text(currentGrade.emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          currentGrade.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: currentGrade.color,
          ),
        ),
        if (nextGrade != null) ...[
          const Spacer(),
          Text(
            'Prochain: ${nextGrade.emoji}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ],
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
                color: goal.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: goal.progress,
          minHeight: 8,
          backgroundColor: Colors.grey[300],
          color: goal.color,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
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
        _buildStatItem(
          '${goal.currentStreak}',
          'Série',
          Icons.local_fire_department,
          Colors.orange,
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          '${goal.maxStreak}',
          'Meilleure',
          Icons.emoji_events,
          Colors.amber,
        ),
        const SizedBox(width: 24),
        _buildStatItem(
          '${goal.totalDays}',
          'Total',
          Icons.calendar_today,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  List<PopupMenuItem<String>> _buildPopupMenuItems() {
    final items = <PopupMenuItem<String>>[];

    // Éditer
    items.add(
      PopupMenuItem(
        value: 'edit',
        child: Row(
          children: [
            Icon(Icons.edit, size: 18, color: Colors.blue),
            const SizedBox(width: 8),
            const Text('Modifier'),
          ],
        ),
      ),
    );

    // Actions selon le statut
    if (goal.isCompleted) {
      // Objectif complété - pas d'actions supplémentaires
    } else if (goal.isActive) {
      // Objectif actif - option de changer
      items.add(
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(Icons.swap_horiz, size: 18, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('Changer d\'objectif'),
            ],
          ),
        ),
      );
    } else {
      // Objectif archivé - option d'activer
      items.add(
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(Icons.play_arrow, size: 18, color: Colors.green),
              const SizedBox(width: 8),
              const Text('Activer'),
            ],
          ),
        ),
      );
    }

    // Supprimer
    items.add(
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete, size: 18, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Supprimer'),
          ],
        ),
      ),
    );

    return items;
  }
}
