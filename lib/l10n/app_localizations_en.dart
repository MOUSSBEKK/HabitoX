// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'HabitoX';

  @override
  String get settings_title => 'Settings';

  @override
  String get language_title => 'Language';

  @override
  String get language_system => 'Use device language';

  @override
  String get language_english => 'English';

  @override
  String get language_french => 'French';

  @override
  String get language_german => 'German';

  @override
  String get language_spanish => 'Spanish';

  @override
  String get theme_title => 'Theme';

  @override
  String get cancel => 'Cancel';

  @override
  String get accep => 'Ok';

  @override
  String get progression => 'Progress';

  @override
  String get onboarding_title =>
      'Transform your daily life by building lasting habits';

  @override
  String get onboarding_popup => 'A few minutes a day to change your life';

  @override
  String get onboarding_btn => 'Next';

  @override
  String get onboarding2_title => 'How does it work?';

  @override
  String get onboarding_title_card1 => 'Set your goals';

  @override
  String get onboarding_title_card2 => 'Track your progress';

  @override
  String get onboarding_title_card3 => 'Celebrate your successes';

  @override
  String get onboarding_subtitles_card1 =>
      'Define the habits you want to develop';

  @override
  String get onboarding_subtitles_card2 =>
      'Mark your daily successes with a simple tap';

  @override
  String get onboarding_subtitles_card3 =>
      'Unlock achievements and level up your life';

  @override
  String get onboarding2_btn => 'Get Started';

  @override
  String get home => 'Home';

  @override
  String get nav_objectives => 'Objectives';

  @override
  String get nav_badges => 'Badges';

  @override
  String get nav_profile => 'Profile';

  @override
  String get bottom_modal_title => 'New objective';

  @override
  String get bottom_modal_title2 => 'Change the objective';

  @override
  String get bottom_modal_icon => 'Icon';

  @override
  String get bottom_modal_icon_title => 'Choose an Icon';

  @override
  String get bottom_modal_icon_categorie1 => 'Sports & Fitness';

  @override
  String get bottom_modal_icon_categorie3 => 'Arts & Creativity';

  @override
  String get bottom_modal_icon_categorie4 => 'Learning & Education';

  @override
  String get bottom_modal_icon_categorie5 => 'Technology & Work';

  @override
  String get bottom_modal_color => 'Colors';

  @override
  String get bottom_modal_color_title => 'Choose a Color';

  @override
  String get bottom_modal_view => 'View All';

  @override
  String get bottom_modal_input_title => 'Objective title';

  @override
  String get bottom_modal_placeholder_title => 'Ex: Learn to play the guitar';

  @override
  String get bottom_modal_error_title => 'Please enter a title';

  @override
  String get bottom_modal_input_desc => 'Description';

  @override
  String get bottom_modal_placeholder_desc => 'Describe your goal...';

  @override
  String get bottom_modal_error_desc => 'Please enter a description';

  @override
  String get bottom_modal_error_duration => 'Minimum duration is 5 days';

  @override
  String get bottom_modal_modal_succes => 'Objective successfully modified';

  @override
  String get bottom_modal_modal_created => 'Goal successfully created';

  @override
  String get bottom_modal_input_start_date => 'Start date';

  @override
  String get bottom_modal_input_start_end => 'End date';

  @override
  String bottom_modal_duration(int duration_days) {
    return 'Duration: $duration_days';
  }

  @override
  String get bottom_modal_btn => 'Create';

  @override
  String get bottom_modal_btn2 => 'Edit';

  @override
  String get calendar_progress => 'Calendar progress';

  @override
  String get calendar_informations => 'Information';

  @override
  String get calendar_mark_session => 'Mark session';

  @override
  String get calendar_completed_days => 'jours complétés';

  @override
  String get calendar_empty_state => 'No Active Goal';

  @override
  String get calender_empty_state_subtitle =>
      'Create your first goal to start your journey';

  @override
  String get calendar_loading => 'Chargement du calendrier...';

  @override
  String get objectives_actif => 'Active';

  @override
  String get objectives_completed => 'Completed';

  @override
  String get objectives_archived => 'Archived';

  @override
  String get objectives_actif_empty_title => 'No Active Target';

  @override
  String get objectives_actif_empty_subtitle =>
      'Start by creating your first goal!';

  @override
  String get objectives_completed_empty_title => 'No Objectives Completed';

  @override
  String get objectives_completed_empty_subtitle =>
      'Complete your goals to see them here';

  @override
  String get objectives_archived_empty_title => 'No Archived Objectives';

  @override
  String get objectives_archived_empty_subtitle =>
      'Archive your goals to organize them';

  @override
  String get objectives_informations => 'Series';

  @override
  String get objectives_informations2 => 'Best';

  @override
  String get objectives_popup1 => 'Stop';

  @override
  String get objectives_popup2 => 'Activate';

  @override
  String get objectives_popup3 => 'Supprimer';

  @override
  String get objectives_popup4 => 'Edit';

  @override
  String get badge_earned => 'Latest Badge Earned';

  @override
  String get badge_level => 'Level';

  @override
  String get badge1_title => 'First Seed';

  @override
  String get badge2_title => 'Growing Roots';

  @override
  String get badge3_title => 'Strong Foundation';

  @override
  String get badge4_title => 'Routine Master';

  @override
  String get badge5_title => 'Habit Champion';

  @override
  String get badge6_title => 'Forest Guardian';

  @override
  String get badge7_title => 'Wisdom Tree';

  @override
  String get badge8_title => 'Life Transformer';

  @override
  String get badge9_title => 'Habit Sage';

  @override
  String get badge1_desc => 'You\'ve planted your first habit.';

  @override
  String get badge2_desc => 'Your routines are taking shape';

  @override
  String get badge3_desc => 'Your habits are well established';

  @override
  String get badge4_desc => 'Your consistency is bearing fruit';

  @override
  String get badge5_desc => 'You inspire others with your dedication';

  @override
  String get badge6_desc => 'You protect and nurture multiple habit trees';

  @override
  String get badge7_desc => 'Your habits have grown into ancient wisdom';

  @override
  String get badge8_desc => 'Your consistency has transformed your entire life';

  @override
  String get badge9_desc => 'You\'ve mastered the art of lasting change';

  @override
  String get upgrade_card_title => 'Upgrade Plan Now';

  @override
  String get upgrade_card_subtitle =>
      'Enjoy all the benefits and explore more possibilities';

  @override
  String get settings_categorie_prefetence => 'Preferences';

  @override
  String get settings_categorie_ressources => 'Resources';

  @override
  String get settings_appearance => 'App Appearance';

  @override
  String get settings_notifications => 'Notifications';

  @override
  String get settings_data_analytics => 'Data & Analytics';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_import => 'Import';

  @override
  String get settings_export => 'Export';

  @override
  String get settings_privacy_policy => 'Privacy Policy';

  @override
  String get settings_app_updates => 'App Updates';

  @override
  String get settings_rate_app => 'Rate the app';

  @override
  String get settings_follow_instagram => 'Follow on Insta';

  @override
  String get premium_monthly => 'Monthly';

  @override
  String get premium_annual => 'Annual';

  @override
  String get premium_life => 'For life';

  @override
  String get premium_subscribe_subtitle => 'Recurring billing. Cancel anytime';

  @override
  String get premium_paiement_subtitle => 'Pay Once. Unlimited access forever';

  @override
  String get premium_feature_title => 'By subscribing, you will also unlock:';

  @override
  String get premium_feature_title1 => 'Access imports and exports';

  @override
  String get premium_feature_title2 => 'Widget on the home screen';

  @override
  String get premium_feature_title3 => 'Access to charts and statistics';

  @override
  String get premium_feature_title4 => 'Custom badges';

  @override
  String get premium_feature_title1_desc =>
      'Back up or migrate your data with ease';

  @override
  String get premium_feature_title2_desc =>
      'Access your favorite habits from the home screen';

  @override
  String get premium_feature_title3_desc => 'View your trends and consistency';

  @override
  String get premium_feature_title4_desc =>
      'Unique rewards tailored to your goals';

  @override
  String get premium_btn => 'Continue';

  @override
  String get notification_title => 'Daily reminders';

  @override
  String get notification => 'Do not forget to complete your task.';

  @override
  String get notification_subtitle =>
      'Get a daily notification so you don\'t forget to complete your goals.';

  @override
  String get notification_toggle_title => 'Turn on notifications';

  @override
  String get notification_toggle_on_subtitle => 'Notifications are enabled';

  @override
  String get notification_toggle_off_subtitle => 'Notifications are disabled';

  @override
  String get notification_time => 'Notification time';

  @override
  String get notification_choose_time =>
      'Choisissez à quelle heure vous souhaitez recevoir votre rappel quotidien.';

  @override
  String get notification_select_time => 'Time modified';

  @override
  String get notification_perms => 'Required permissions';

  @override
  String get notification_perms_subtitle =>
      'To receive notifications, you must allow the app to send you notifications in your device settings.';

  @override
  String get analytics_completions => 'Completions';

  @override
  String get analytics_archives => 'Archived';

  @override
  String get analytics_completions_day => 'Completions / Day';

  @override
  String get analytics_marking_omissions => 'Markings vs. Omissions';

  @override
  String get analytics_marking => 'Markings';

  @override
  String get analytics_omissions => 'Forget';

  @override
  String get analytics_nodata => 'No data';

  @override
  String get toastification_privacy_error =>
      'Unable to open the privacy policy';

  @override
  String get toastification_insta_error => 'Unable to open Instagram';

  @override
  String get toastification_review => 'Thank you for your feedback.';

  @override
  String get toastification_error_title => 'Error';

  @override
  String get toastification_error_desc =>
      'Unable to open the rating. Redirecting to the store...';

  @override
  String get toastification_error_redirecting_desc =>
      'Unable to open the store. Please note the app manually.';

  @override
  String get toastification_session_completed => 'Session marked as completed';

  @override
  String get toastification_goal_completed => 'Goal Completed';

  @override
  String get modal_delete_confirmation_title => 'Confirm deletion';

  @override
  String get modal_delete_confirmation_desc => 'Confirm deletion';

  @override
  String get modal_delete_confirmation_label => 'Delete';
}
