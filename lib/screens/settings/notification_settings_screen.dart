import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../services/notification_service.dart';
import '../../l10n/app_localizations.dart';
import 'package:hugeicons_pro/hugeicons.dart';

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings_notifications),
      ),
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
              AppLocalizations.of(context)!.notification_title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.notification_subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              activeThumbColor: Theme.of(context).colorScheme.secondary,
              title: Text(
                AppLocalizations.of(context)!.notification_toggle_title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              subtitle: notificationService.notificationsEnabled
                  ? Text(
                      AppLocalizations.of(
                        context,
                      )!.notification_toggle_on_subtitle,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(
                        context,
                      )!.notification_toggle_off_subtitle,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
              value: notificationService.notificationsEnabled,
              onChanged: (bool value) async {
                await notificationService.setNotificationsEnabled(value);

                if (value && !notificationService.notificationsEnabled) {
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
              AppLocalizations.of(context)!.notification_time,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.notification_choose_time,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                HugeIconsStroke.clock02,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                AppLocalizations.of(context)!.notification_time,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                '${notificationService.notificationHour.toString().padLeft(2, '0')}:${notificationService.notificationMinute.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () => _selectTime(notificationService),
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
          title: Text(AppLocalizations.of(context)!.notification_select_time),
          description: Text(
            'Les notifications seront envoyées à ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
          ),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.notification_perms),
          content: Text(
            AppLocalizations.of(context)!.notification_perms_subtitle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.accep),
            ),
          ],
        );
      },
    );
  }
}
