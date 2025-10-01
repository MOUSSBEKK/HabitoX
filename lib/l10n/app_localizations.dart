import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'HabitoX'**
  String get app_title;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_title;

  /// No description provided for @language_system.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get language_system;

  /// No description provided for @language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @language_french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get language_french;

  /// No description provided for @language_german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get language_german;

  /// No description provided for @language_spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get language_spanish;

  /// No description provided for @theme_title.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme_title;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @accep.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get accep;

  /// No description provided for @progression.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progression;

  /// No description provided for @onboarding_title.
  ///
  /// In en, this message translates to:
  /// **'Transform your daily life by building lasting habits'**
  String get onboarding_title;

  /// No description provided for @onboarding_popup.
  ///
  /// In en, this message translates to:
  /// **'A few minutes a day to change your life'**
  String get onboarding_popup;

  /// No description provided for @onboarding_btn.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_btn;

  /// No description provided for @onboarding2_title.
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
  String get onboarding2_title;

  /// No description provided for @onboarding_title_card1.
  ///
  /// In en, this message translates to:
  /// **'Set your goals'**
  String get onboarding_title_card1;

  /// No description provided for @onboarding_title_card2.
  ///
  /// In en, this message translates to:
  /// **'Track your progress'**
  String get onboarding_title_card2;

  /// No description provided for @onboarding_title_card3.
  ///
  /// In en, this message translates to:
  /// **'Celebrate your successes'**
  String get onboarding_title_card3;

  /// No description provided for @onboarding_subtitles_card1.
  ///
  /// In en, this message translates to:
  /// **'Define the habits you want to develop'**
  String get onboarding_subtitles_card1;

  /// No description provided for @onboarding_subtitles_card2.
  ///
  /// In en, this message translates to:
  /// **'Mark your daily successes with a simple tap'**
  String get onboarding_subtitles_card2;

  /// No description provided for @onboarding_subtitles_card3.
  ///
  /// In en, this message translates to:
  /// **'Unlock achievements and level up your life'**
  String get onboarding_subtitles_card3;

  /// No description provided for @onboarding2_btn.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding2_btn;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @nav_objectives.
  ///
  /// In en, this message translates to:
  /// **'Objectives'**
  String get nav_objectives;

  /// No description provided for @nav_badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get nav_badges;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @bottom_modal_title.
  ///
  /// In en, this message translates to:
  /// **'New objective'**
  String get bottom_modal_title;

  /// No description provided for @bottom_modal_title2.
  ///
  /// In en, this message translates to:
  /// **'Change the objective'**
  String get bottom_modal_title2;

  /// No description provided for @bottom_modal_icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get bottom_modal_icon;

  /// No description provided for @bottom_modal_icon_title.
  ///
  /// In en, this message translates to:
  /// **'Choose an Icon'**
  String get bottom_modal_icon_title;

  /// No description provided for @bottom_modal_icon_categorie1.
  ///
  /// In en, this message translates to:
  /// **'Sports & Fitness'**
  String get bottom_modal_icon_categorie1;

  /// No description provided for @bottom_modal_icon_categorie3.
  ///
  /// In en, this message translates to:
  /// **'Arts & Creativity'**
  String get bottom_modal_icon_categorie3;

  /// No description provided for @bottom_modal_icon_categorie4.
  ///
  /// In en, this message translates to:
  /// **'Learning & Education'**
  String get bottom_modal_icon_categorie4;

  /// No description provided for @bottom_modal_icon_categorie5.
  ///
  /// In en, this message translates to:
  /// **'Technology & Work'**
  String get bottom_modal_icon_categorie5;

  /// No description provided for @bottom_modal_color.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get bottom_modal_color;

  /// No description provided for @bottom_modal_color_title.
  ///
  /// In en, this message translates to:
  /// **'Choose a Color'**
  String get bottom_modal_color_title;

  /// No description provided for @bottom_modal_view.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get bottom_modal_view;

  /// No description provided for @bottom_modal_input_title.
  ///
  /// In en, this message translates to:
  /// **'Objective title'**
  String get bottom_modal_input_title;

  /// No description provided for @bottom_modal_placeholder_title.
  ///
  /// In en, this message translates to:
  /// **'Ex: Learn to play the guitar'**
  String get bottom_modal_placeholder_title;

  /// No description provided for @bottom_modal_error_title.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get bottom_modal_error_title;

  /// No description provided for @bottom_modal_input_desc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get bottom_modal_input_desc;

  /// No description provided for @bottom_modal_placeholder_desc.
  ///
  /// In en, this message translates to:
  /// **'Describe your goal...'**
  String get bottom_modal_placeholder_desc;

  /// No description provided for @bottom_modal_error_desc.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get bottom_modal_error_desc;

  /// No description provided for @bottom_modal_modal_succes.
  ///
  /// In en, this message translates to:
  /// **'Objective successfully modified'**
  String get bottom_modal_modal_succes;

  /// No description provided for @bottom_modal_modal_created.
  ///
  /// In en, this message translates to:
  /// **'Goal successfully created'**
  String get bottom_modal_modal_created;

  /// No description provided for @bottom_modal_input_start_date.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get bottom_modal_input_start_date;

  /// No description provided for @bottom_modal_input_start_end.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get bottom_modal_input_start_end;

  /// No description provided for @bottom_modal_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration_days}'**
  String bottom_modal_duration(int duration_days);

  /// No description provided for @bottom_modal_btn.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get bottom_modal_btn;

  /// No description provided for @bottom_modal_btn2.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get bottom_modal_btn2;

  /// No description provided for @calendar_progress.
  ///
  /// In en, this message translates to:
  /// **'Calendar progress'**
  String get calendar_progress;

  /// No description provided for @calendar_informations.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get calendar_informations;

  /// No description provided for @calendar_mark_session.
  ///
  /// In en, this message translates to:
  /// **'Mark session'**
  String get calendar_mark_session;

  /// No description provided for @calendar_completed_days.
  ///
  /// In en, this message translates to:
  /// **'jours complétés'**
  String get calendar_completed_days;

  /// No description provided for @calendar_empty_state.
  ///
  /// In en, this message translates to:
  /// **'No Active Goal'**
  String get calendar_empty_state;

  /// No description provided for @calender_empty_state_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first goal to start your journey'**
  String get calender_empty_state_subtitle;

  /// No description provided for @calendar_loading.
  ///
  /// In en, this message translates to:
  /// **'Chargement du calendrier...'**
  String get calendar_loading;

  /// No description provided for @objectives_actif.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get objectives_actif;

  /// No description provided for @objectives_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get objectives_completed;

  /// No description provided for @objectives_archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get objectives_archived;

  /// No description provided for @objectives_actif_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No Active Target'**
  String get objectives_actif_empty_title;

  /// No description provided for @objectives_actif_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by creating your first goal!'**
  String get objectives_actif_empty_subtitle;

  /// No description provided for @objectives_completed_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No Objectives Completed'**
  String get objectives_completed_empty_title;

  /// No description provided for @objectives_completed_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your goals to see them here'**
  String get objectives_completed_empty_subtitle;

  /// No description provided for @objectives_archived_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No Archived Objectives'**
  String get objectives_archived_empty_title;

  /// No description provided for @objectives_archived_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Archive your goals to organize them'**
  String get objectives_archived_empty_subtitle;

  /// No description provided for @objectives_informations.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get objectives_informations;

  /// No description provided for @objectives_informations2.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get objectives_informations2;

  /// No description provided for @objectives_popup1.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get objectives_popup1;

  /// No description provided for @objectives_popup2.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get objectives_popup2;

  /// No description provided for @objectives_popup3.
  ///
  /// In en, this message translates to:
  /// **'Supprimer'**
  String get objectives_popup3;

  /// No description provided for @objectives_popup4.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get objectives_popup4;

  /// No description provided for @badge_earned.
  ///
  /// In en, this message translates to:
  /// **'Latest Badge Earned'**
  String get badge_earned;

  /// No description provided for @badge_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get badge_level;

  /// No description provided for @badge1_title.
  ///
  /// In en, this message translates to:
  /// **'First Seed'**
  String get badge1_title;

  /// No description provided for @badge2_title.
  ///
  /// In en, this message translates to:
  /// **'Growing Roots'**
  String get badge2_title;

  /// No description provided for @badge3_title.
  ///
  /// In en, this message translates to:
  /// **'Strong Foundation'**
  String get badge3_title;

  /// No description provided for @badge4_title.
  ///
  /// In en, this message translates to:
  /// **'Routine Master'**
  String get badge4_title;

  /// No description provided for @badge5_title.
  ///
  /// In en, this message translates to:
  /// **'Habit Champion'**
  String get badge5_title;

  /// No description provided for @badge6_title.
  ///
  /// In en, this message translates to:
  /// **'Forest Guardian'**
  String get badge6_title;

  /// No description provided for @badge7_title.
  ///
  /// In en, this message translates to:
  /// **'Wisdom Tree'**
  String get badge7_title;

  /// No description provided for @badge8_title.
  ///
  /// In en, this message translates to:
  /// **'Life Transformer'**
  String get badge8_title;

  /// No description provided for @badge9_title.
  ///
  /// In en, this message translates to:
  /// **'Habit Sage'**
  String get badge9_title;

  /// No description provided for @badge1_desc.
  ///
  /// In en, this message translates to:
  /// **'You\'ve planted your first habit.'**
  String get badge1_desc;

  /// No description provided for @badge2_desc.
  ///
  /// In en, this message translates to:
  /// **'Your routines are taking shape'**
  String get badge2_desc;

  /// No description provided for @badge3_desc.
  ///
  /// In en, this message translates to:
  /// **'Your habits are well established'**
  String get badge3_desc;

  /// No description provided for @badge4_desc.
  ///
  /// In en, this message translates to:
  /// **'Your consistency is bearing fruit'**
  String get badge4_desc;

  /// No description provided for @badge5_desc.
  ///
  /// In en, this message translates to:
  /// **'You inspire others with your dedication'**
  String get badge5_desc;

  /// No description provided for @badge6_desc.
  ///
  /// In en, this message translates to:
  /// **'You protect and nurture multiple habit trees'**
  String get badge6_desc;

  /// No description provided for @badge7_desc.
  ///
  /// In en, this message translates to:
  /// **'Your habits have grown into ancient wisdom'**
  String get badge7_desc;

  /// No description provided for @badge8_desc.
  ///
  /// In en, this message translates to:
  /// **'Your consistency has transformed your entire life'**
  String get badge8_desc;

  /// No description provided for @badge9_desc.
  ///
  /// In en, this message translates to:
  /// **'You\'ve mastered the art of lasting change'**
  String get badge9_desc;

  /// No description provided for @upgrade_card_title.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan Now'**
  String get upgrade_card_title;

  /// No description provided for @upgrade_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoy all the benefits and explore more possibilities'**
  String get upgrade_card_subtitle;

  /// No description provided for @settings_categorie_prefetence.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settings_categorie_prefetence;

  /// No description provided for @settings_categorie_ressources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get settings_categorie_ressources;

  /// No description provided for @settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'App Appearance'**
  String get settings_appearance;

  /// No description provided for @settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_notifications;

  /// No description provided for @settings_data_analytics.
  ///
  /// In en, this message translates to:
  /// **'Data & Analytics'**
  String get settings_data_analytics;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settings_import;

  /// No description provided for @settings_export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get settings_export;

  /// No description provided for @settings_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacy_policy;

  /// No description provided for @settings_app_updates.
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get settings_app_updates;

  /// No description provided for @settings_rate_app.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get settings_rate_app;

  /// No description provided for @settings_follow_instagram.
  ///
  /// In en, this message translates to:
  /// **'Follow on Insta'**
  String get settings_follow_instagram;

  /// No description provided for @premium_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get premium_monthly;

  /// No description provided for @premium_annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get premium_annual;

  /// No description provided for @premium_life.
  ///
  /// In en, this message translates to:
  /// **'For life'**
  String get premium_life;

  /// No description provided for @premium_subscribe_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring billing. Cancel anytime'**
  String get premium_subscribe_subtitle;

  /// No description provided for @premium_paiement_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay Once. Unlimited access forever'**
  String get premium_paiement_subtitle;

  /// No description provided for @premium_feature_title.
  ///
  /// In en, this message translates to:
  /// **'By subscribing, you will also unlock:'**
  String get premium_feature_title;

  /// No description provided for @premium_feature_title1.
  ///
  /// In en, this message translates to:
  /// **'Access imports and exports'**
  String get premium_feature_title1;

  /// No description provided for @premium_feature_title2.
  ///
  /// In en, this message translates to:
  /// **'Widget on the home screen'**
  String get premium_feature_title2;

  /// No description provided for @premium_feature_title3.
  ///
  /// In en, this message translates to:
  /// **'Access to charts and statistics'**
  String get premium_feature_title3;

  /// No description provided for @premium_feature_title4.
  ///
  /// In en, this message translates to:
  /// **'Custom badges'**
  String get premium_feature_title4;

  /// No description provided for @premium_feature_title1_desc.
  ///
  /// In en, this message translates to:
  /// **'Back up or migrate your data with ease'**
  String get premium_feature_title1_desc;

  /// No description provided for @premium_feature_title2_desc.
  ///
  /// In en, this message translates to:
  /// **'Access your favorite habits from the home screen'**
  String get premium_feature_title2_desc;

  /// No description provided for @premium_feature_title3_desc.
  ///
  /// In en, this message translates to:
  /// **'View your trends and consistency'**
  String get premium_feature_title3_desc;

  /// No description provided for @premium_feature_title4_desc.
  ///
  /// In en, this message translates to:
  /// **'Unique rewards tailored to your goals'**
  String get premium_feature_title4_desc;

  /// No description provided for @premium_btn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get premium_btn;

  /// No description provided for @notification_title.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders'**
  String get notification_title;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Do not forget to complete your task.'**
  String get notification;

  /// No description provided for @notification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a daily notification so you don\'t forget to complete your goals.'**
  String get notification_subtitle;

  /// No description provided for @notification_toggle_title.
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications'**
  String get notification_toggle_title;

  /// No description provided for @notification_toggle_on_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are enabled'**
  String get notification_toggle_on_subtitle;

  /// No description provided for @notification_toggle_off_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled'**
  String get notification_toggle_off_subtitle;

  /// No description provided for @notification_time.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get notification_time;

  /// No description provided for @notification_choose_time.
  ///
  /// In en, this message translates to:
  /// **'Choisissez à quelle heure vous souhaitez recevoir votre rappel quotidien.'**
  String get notification_choose_time;

  /// No description provided for @notification_select_time.
  ///
  /// In en, this message translates to:
  /// **'Time modified'**
  String get notification_select_time;

  /// No description provided for @notification_perms.
  ///
  /// In en, this message translates to:
  /// **'Required permissions'**
  String get notification_perms;

  /// No description provided for @notification_perms_subtitle.
  ///
  /// In en, this message translates to:
  /// **'To receive notifications, you must allow the app to send you notifications in your device settings.'**
  String get notification_perms_subtitle;

  /// No description provided for @analytics_completions.
  ///
  /// In en, this message translates to:
  /// **'Completions'**
  String get analytics_completions;

  /// No description provided for @analytics_archives.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get analytics_archives;

  /// No description provided for @analytics_completions_day.
  ///
  /// In en, this message translates to:
  /// **'Completions / Day'**
  String get analytics_completions_day;

  /// No description provided for @analytics_marking_omissions.
  ///
  /// In en, this message translates to:
  /// **'Markings vs. Omissions'**
  String get analytics_marking_omissions;

  /// No description provided for @analytics_marking.
  ///
  /// In en, this message translates to:
  /// **'Markings'**
  String get analytics_marking;

  /// No description provided for @analytics_omissions.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get analytics_omissions;

  /// No description provided for @analytics_nodata.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get analytics_nodata;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
