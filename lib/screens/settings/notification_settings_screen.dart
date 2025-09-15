import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres de notifications')),
      body: SafeArea(
        child: Consumer<NotificationService>(
          builder: (context, notificationService, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationToggle(notificationService),
                  const SizedBox(height: 24),
                  if (notificationService.notificationsEnabled) ...[
                    _buildTimeSelector(notificationService),
                    const SizedBox(height: 24),
                  ],
                  _buildTestSection(notificationService),
                  const SizedBox(height: 24),
                  _buildInfoSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(NotificationService notificationService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rappels quotidiens',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Recevez une notification chaque jour pour ne pas oublier de remplir vos objectifs.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Activer les notifications'),
              subtitle: notificationService.notificationsEnabled
                  ? const Text('Les notifications sont activées')
                  : const Text('Les notifications sont désactivées'),
              value: notificationService.notificationsEnabled,
              onChanged: (bool value) async {
                await notificationService.setNotificationsEnabled(value);

                if (value && !notificationService.notificationsEnabled) {
                  // Les permissions ont été refusées
                  _showPermissionDeniedDialog();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(NotificationService notificationService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heure de notification',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Choisissez à quelle heure vous souhaitez recevoir votre rappel quotidien.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Heure de notification'),
              subtitle: Text(
                '${notificationService.notificationHour.toString().padLeft(2, '0')}:${notificationService.notificationMinute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _selectTime(notificationService),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection(NotificationService notificationService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test des notifications',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Testez si les notifications fonctionnent correctement sur votre appareil.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _testNotification(notificationService),
                icon: const Icon(Icons.notifications),
                label: const Text('Envoyer une notification de test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '• Les notifications vous rappellent de remplir vos objectifs quotidiens\n'
              '• Vous pouvez modifier l\'heure à tout moment\n'
              '• Les notifications respectent les paramètres système de votre appareil\n'
              '• Sur certains appareils, vous devrez autoriser l\'application à fonctionner en arrière-plan',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(NotificationService notificationService) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: notificationService.notificationHour,
        minute: notificationService.notificationMinute,
      ),
    );

    if (selectedTime != null) {
      await notificationService.setNotificationTime(
        selectedTime.hour,
        selectedTime.minute,
      );

      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Heure modifiée'),
          description: Text(
            'Les notifications seront envoyées à ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
          ),
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _testNotification(
    NotificationService notificationService,
  ) async {
    try {
      await notificationService.showTestNotification();

      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Notification envoyée !'),
          description: const Text(
            'Si vous ne recevez pas la notification, vérifiez les paramètres de votre appareil.',
          ),
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Erreur'),
          description: Text('Impossible d\'envoyer la notification: $e'),
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions requises'),
          content: const Text(
            'Pour recevoir des notifications, vous devez autoriser l\'application à vous envoyer des notifications dans les paramètres de votre appareil.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
