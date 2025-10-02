// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get app_title => 'HabitoX';

  @override
  String get settings_title => 'Paramètres';

  @override
  String get language_title => 'Langue';

  @override
  String get language_system => 'Langue de l\'appareil';

  @override
  String get language_english => 'Anglais';

  @override
  String get language_french => 'Français';

  @override
  String get language_german => 'Allemand';

  @override
  String get language_spanish => 'Espagnol';

  @override
  String get theme_title => 'Thème';

  @override
  String get cancel => 'Annuler';

  @override
  String get accep => 'Ok';

  @override
  String get progression => 'Progression';

  @override
  String get onboarding_title =>
      'Transformez votre quotidien en construisant des habitudes durables';

  @override
  String get onboarding_popup =>
      'Quelques minutes par jour pour changer votre vie';

  @override
  String get onboarding_btn => 'Suivant';

  @override
  String get onboarding2_title => 'Comment ça marche ?';

  @override
  String get onboarding_title_card1 => 'Définissez vos objectifs';

  @override
  String get onboarding_title_card2 => 'Suivez vos progrès';

  @override
  String get onboarding_title_card3 => 'Célébrez vos réussites';

  @override
  String get onboarding_subtitles_card1 =>
      'Définissez les habitudes que vous souhaitez développer';

  @override
  String get onboarding_subtitles_card2 =>
      'Marquez vos réussites quotidiennes d\'une simple pression';

  @override
  String get onboarding_subtitles_card3 =>
      'Débloquez des succès et montez de niveau';

  @override
  String get onboarding2_btn => 'Commencer';

  @override
  String get home => 'Accueil';

  @override
  String get nav_objectives => 'Objectifs';

  @override
  String get nav_badges => 'Badges';

  @override
  String get nav_profile => 'Profil';

  @override
  String get bottom_modal_title => 'Nouvel objectif';

  @override
  String get bottom_modal_title2 => 'Modifier l\'objectif';

  @override
  String get bottom_modal_icon => 'Icône';

  @override
  String get bottom_modal_icon_title => 'Choisir une Icône';

  @override
  String get bottom_modal_icon_categorie1 => 'Sport & Fitness';

  @override
  String get bottom_modal_icon_categorie3 => 'Arts & Créativité';

  @override
  String get bottom_modal_icon_categorie4 => 'Apprentissage & Éducation';

  @override
  String get bottom_modal_icon_categorie5 => 'Technologie & Travail';

  @override
  String get bottom_modal_color => 'Couleurs';

  @override
  String get bottom_modal_color_title => 'Choisir une Couleur';

  @override
  String get bottom_modal_view => 'Tout voir';

  @override
  String get bottom_modal_input_title => 'Titre de l\'objectif';

  @override
  String get bottom_modal_placeholder_title =>
      'Ex: Apprendre à jouer de la guitare';

  @override
  String get bottom_modal_error_title => 'Veuillez entrer un titre';

  @override
  String get bottom_modal_input_desc => 'Description';

  @override
  String get bottom_modal_placeholder_desc => 'Décrivez votre objectif...';

  @override
  String get bottom_modal_error_desc => 'Veuillez entrer une description';

  @override
  String get bottom_modal_modal_succes => 'Objectif modifié avec succès';

  @override
  String get bottom_modal_modal_created => 'Objectif créé avec succès';

  @override
  String get bottom_modal_input_start_date => 'Date de début';

  @override
  String get bottom_modal_input_start_end => 'Date de fin';

  @override
  String bottom_modal_duration(int duration_days) {
    return 'Durée : $duration_days';
  }

  @override
  String get bottom_modal_btn => 'Créer';

  @override
  String get bottom_modal_btn2 => 'Modifier';

  @override
  String get calendar_progress => 'Progression du calendrier';

  @override
  String get calendar_informations => 'Informations';

  @override
  String get calendar_mark_session => 'Marquer la session';

  @override
  String get calendar_completed_days => 'jours complétés';

  @override
  String get calendar_empty_state => 'Aucun objectif actif';

  @override
  String get calender_empty_state_subtitle =>
      'Créez votre premier objectif pour démarrer votre parcours';

  @override
  String get calendar_loading => 'Chargement du calendrier...';

  @override
  String get objectives_actif => 'Actifs';

  @override
  String get objectives_completed => 'Terminés';

  @override
  String get objectives_archived => 'Archivés';

  @override
  String get objectives_actif_empty_title => 'Aucun objectif actif';

  @override
  String get objectives_actif_empty_subtitle =>
      'Commencez par créer votre premier objectif !';

  @override
  String get objectives_completed_empty_title => 'Aucun objectif terminé';

  @override
  String get objectives_completed_empty_subtitle =>
      'Terminez vos objectifs pour les voir ici';

  @override
  String get objectives_archived_empty_title => 'Aucun objectif archivé';

  @override
  String get objectives_archived_empty_subtitle =>
      'Archivez vos objectifs pour les organiser';

  @override
  String get objectives_informations => 'Séries';

  @override
  String get objectives_informations2 => 'Meilleur';

  @override
  String get objectives_popup1 => 'Arrêter';

  @override
  String get objectives_popup2 => 'Activer';

  @override
  String get objectives_popup3 => 'Supprimer';

  @override
  String get objectives_popup4 => 'Modifier';

  @override
  String get badge_earned => 'Dernier badge obtenu';

  @override
  String get badge_level => 'Niveau';

  @override
  String get badge1_title => 'Première Graine';

  @override
  String get badge2_title => 'Racines Grandissantes';

  @override
  String get badge3_title => 'Fondation Solide';

  @override
  String get badge4_title => 'Maître de Routine';

  @override
  String get badge5_title => 'Champion d\'Habitude';

  @override
  String get badge6_title => 'Gardien de Forêt';

  @override
  String get badge7_title => 'Arbre de Sagesse';

  @override
  String get badge8_title => 'Transformateur de Vie';

  @override
  String get badge9_title => 'Sage d\'Habitude';

  @override
  String get badge1_desc => 'Vous avez planté votre première habitude.';

  @override
  String get badge2_desc => 'Vos routines prennent forme';

  @override
  String get badge3_desc => 'Vos habitudes sont bien établies';

  @override
  String get badge4_desc => 'Votre constance porte ses fruits';

  @override
  String get badge5_desc => 'Vous inspirez les autres par votre dévouement';

  @override
  String get badge6_desc =>
      'Vous protégez et nourrissez plusieurs arbres d\'habitudes';

  @override
  String get badge7_desc => 'Vos habitudes ont grandi en sagesse ancienne';

  @override
  String get badge8_desc => 'Votre constance a transformé toute votre vie';

  @override
  String get badge9_desc => 'Vous avez maîtrisé l\'art du changement durable';

  @override
  String get upgrade_card_title => 'Passer au plan supérieur';

  @override
  String get upgrade_card_subtitle =>
      'Profitez de tous les avantages et explorez plus de possibilités';

  @override
  String get settings_categorie_prefetence => 'Préférences';

  @override
  String get settings_categorie_ressources => 'Ressources';

  @override
  String get settings_appearance => 'Apparence de l\'application';

  @override
  String get settings_notifications => 'Notifications';

  @override
  String get settings_data_analytics => 'Données & Analyses';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_import => 'Importer';

  @override
  String get settings_export => 'Exporter';

  @override
  String get settings_privacy_policy => 'Politique de confidentialité';

  @override
  String get settings_app_updates => 'Mises à jour de l\'app';

  @override
  String get settings_rate_app => 'Noter l\'application';

  @override
  String get settings_follow_instagram => 'Suivre sur Insta';

  @override
  String get premium_monthly => 'Mensuel';

  @override
  String get premium_annual => 'Annuel';

  @override
  String get premium_life => 'À vie';

  @override
  String get premium_subscribe_subtitle =>
      'Facturation récurrente. Annulation à tout moment';

  @override
  String get premium_paiement_subtitle =>
      'Paiement unique. Accès illimité à vie';

  @override
  String get premium_feature_title =>
      'En vous abonnant, vous débloquerez aussi :';

  @override
  String get premium_feature_title1 => 'Accès aux imports et exports';

  @override
  String get premium_feature_title2 => 'Widget sur l’écran d’accueil';

  @override
  String get premium_feature_title3 => 'Accès aux graphiques et statistiques';

  @override
  String get premium_feature_title4 => 'Badges personnalisés';

  @override
  String get premium_feature_title1_desc =>
      'Sauvegardez ou migrez vos données facilement';

  @override
  String get premium_feature_title2_desc =>
      'Accédez à vos habitudes favorites depuis l’écran d’accueil';

  @override
  String get premium_feature_title3_desc =>
      'Visualisez vos tendances et votre régularité';

  @override
  String get premium_feature_title4_desc =>
      'Récompenses uniques adaptées à vos objectifs';

  @override
  String get premium_btn => 'Continuer';

  @override
  String get notification_title => 'Rappels quotidiens';

  @override
  String get notification => 'N\'oubliez pas de compléter votre tâche.';

  @override
  String get notification_subtitle =>
      'Recevez une notification quotidienne pour ne pas oublier de compléter vos objectifs.';

  @override
  String get notification_toggle_title => 'Activer les notifications';

  @override
  String get notification_toggle_on_subtitle =>
      'Les notifications sont activées';

  @override
  String get notification_toggle_off_subtitle =>
      'Les notifications sont désactivées';

  @override
  String get notification_time => 'Heure de notification';

  @override
  String get notification_choose_time =>
      'Choisissez à quelle heure vous souhaitez recevoir votre rappel quotidien.';

  @override
  String get notification_select_time => 'Heure modifiée';

  @override
  String get notification_perms => 'Autorisations requises';

  @override
  String get notification_perms_subtitle =>
      'Pour recevoir des notifications, vous devez autoriser l\'application à vous envoyer des notifications dans les réglages de votre appareil.';

  @override
  String get analytics_completions => 'Accomplissements';

  @override
  String get analytics_archives => 'Archivés';

  @override
  String get analytics_completions_day => 'Accomplissements / jour';

  @override
  String get analytics_marking_omissions => 'Marquages vs. Oublis';

  @override
  String get analytics_marking => 'Marquages';

  @override
  String get analytics_omissions => 'Oublis';

  @override
  String get analytics_nodata => 'Aucune donnée';

  @override
  String get toastification_privacy_error =>
      'Impossible d\'ouvrir la politique de confidentialité';

  @override
  String get toastification_insta_error => 'Impossible d\'ouvrir Instagram';

  @override
  String get toastification_review => 'Merci pour votre retour.';

  @override
  String get toastification_error_title => 'Erreur';

  @override
  String get toastification_error_desc =>
      'Impossible d\'ouvrir l\'évaluation. Redirection vers le magasin...';

  @override
  String get toastification_error_redirecting_desc =>
      'Impossible d\'ouvrir le magasin. Veuillez noter l\'application manuellement.';

  @override
  String get toastification_session_completed =>
      'Session marquée comme terminée';

  @override
  String get toastification_goal_completed => 'Objectif Terminé';

  @override
  String get modal_delete_confirmation_title => 'Confirm deletion';

  @override
  String get modal_delete_confirmation_desc => 'Confirm deletion';

  @override
  String get modal_delete_confirmation_label => 'Delete';
}
