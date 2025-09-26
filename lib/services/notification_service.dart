import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _notificationsEnabled = false;
  bool _isInitialized = false;
  bool _isInitializing = false;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;

  static const String _notificationEnabledKey = 'notifications_enabled';
  static const String _notificationTimeKey = 'notification_time';

  // Heure par défaut : 20h00
  int _notificationHour = 20;
  int _notificationMinute = 0;

  int get notificationHour => _notificationHour;
  int get notificationMinute => _notificationMinute;

  Future<void> initialize() async {
    // Éviter les initialisations multiples
    if (_isInitialized || _isInitializing) {
      return;
    }

    try {
      _isInitializing = true;
      notifyListeners();

      // Initialiser les données de timezone
      tz.initializeTimeZones();

      // Configuration pour Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuration pour iOS
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        // onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Charger les préférences
      await _loadPreferences();

      _isInitialized = true;
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'initialisation des notifications: $e');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool(_notificationEnabledKey) ?? false;

    // Charger l'heure de notification
    final timeString = prefs.getString(_notificationTimeKey);
    if (timeString != null) {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        _notificationHour = int.tryParse(parts[0]) ?? 20;
        _notificationMinute = int.tryParse(parts[1]) ?? 0;
      }
    }

    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, _notificationsEnabled);
    await prefs.setString(
      _notificationTimeKey,
      '$_notificationHour:$_notificationMinute',
    );
  }

  Future<bool> requestPermissions() async {
    bool? result;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      result = await androidImplementation?.requestNotificationsPermission();
    }

    return result ?? false;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;

    if (enabled) {
      // Demander les permissions si ce n'est pas déjà fait
      final permissionGranted = await requestPermissions();
      if (permissionGranted) {
        await _scheduleDailyNotification();
      } else {
        _notificationsEnabled = false;
      }
    } else {
      await cancelAllNotifications();
    }

    await _savePreferences();
    notifyListeners();
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    _notificationHour = hour;
    _notificationMinute = minute;

    await _savePreferences();

    // Reprogrammer la notification si elle est activée
    if (_notificationsEnabled) {
      await _scheduleDailyNotification();
    }

    notifyListeners();
  }

  Future<void> _scheduleDailyNotification() async {
    // Annuler les notifications existantes
    await cancelAllNotifications();

    // Créer un canal de notification pour Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'daily_reminder_channel',
          'Rappels quotidiens',
          channelDescription:
              'Notifications pour rappeler de remplir vos objectifs quotidiens',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(categoryIdentifier: 'daily_reminder');

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Calculer la prochaine occurrence
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      _notificationHour,
      _notificationMinute,
    );

    // Si l'heure est déjà passée aujourd'hui, programmer pour demain
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID de la notification
      'N\'oubliez pas vos objectifs !',
      'Il est temps de remplir vos objectifs quotidiens dans HabitoX',
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time, // Répéter quotidiennement
    );
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'test_channel',
          'Notifications de test',
          channelDescription: 'Canal pour tester les notifications',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      999, // ID unique pour les notifications de test
      'Test de notification',
      'Votre système de notifications fonctionne correctement !',
      platformChannelSpecifics,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
