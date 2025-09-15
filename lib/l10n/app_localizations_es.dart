// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'HabitoX';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get language_title => 'Idioma';

  @override
  String get language_system => 'Usar idioma del dispositivo';

  @override
  String get language_english => 'Inglés';

  @override
  String get language_french => 'Francés';

  @override
  String get language_german => 'Alemán';

  @override
  String get language_spanish => 'Español';

  @override
  String get theme_title => 'Tema';

  @override
  String get cancel => 'Cancel';

  @override
  String get accep => 'Ok';

  @override
  String get onboarding_title =>
      'Transforma tu día a día creando hábitos duraderos';

  @override
  String get onboarding_popup => 'Unos minutos al día para cambiar tu vida';

  @override
  String get onboarding_btn => 'Siguiente';

  @override
  String get onboarding2_title => '¿Cómo funciona?';

  @override
  String get onboarding_title_card1 => 'Define tus objetivos';

  @override
  String get onboarding_title_card2 => 'Sigue tu progreso';

  @override
  String get onboarding_title_card3 => 'Celebra tus éxitos';

  @override
  String get onboarding_subtitles_card1 =>
      'Define los hábitos que quieres desarrollar';

  @override
  String get onboarding_subtitles_card2 =>
      'Marca tus logros diarios con un simple toque';

  @override
  String get onboarding_subtitles_card3 => 'Desbloquea logros y sube de nivel';

  @override
  String get onboarding2_btn => 'Empezar';

  @override
  String get home => 'Inicio';

  @override
  String get nav_objectives => 'Objetivos';

  @override
  String get nav_badges => 'Insignias';

  @override
  String get nav_profile => 'Perfil';

  @override
  String get bottom_modal_title => 'Nuevo objetivo';

  @override
  String get bottom_modal_title2 => 'Change the objective';

  @override
  String get bottom_modal_icon => 'Icono';

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
  String get bottom_modal_color => 'Colores';

  @override
  String get bottom_modal_color_title => 'Choose a Color';

  @override
  String get bottom_modal_view => 'Ver todo';

  @override
  String get bottom_modal_input_title => 'Título del objetivo';

  @override
  String get bottom_modal_placeholder_title => 'Ex: Learn to play the guitar';

  @override
  String get bottom_modal_error_title => 'Please enter a title';

  @override
  String get bottom_modal_input_desc => 'Descripción';

  @override
  String get bottom_modal_placeholder_desc => 'Describe your goal...';

  @override
  String get bottom_modal_error_desc => 'Please enter a description';

  @override
  String get bottom_modal_modal_succes => 'Objective successfully modified';

  @override
  String get bottom_modal_modal_created => 'Goal successfully created';

  @override
  String get bottom_modal_input_start_date => 'Fecha de inicio';

  @override
  String get bottom_modal_input_start_end => 'Fecha de fin';

  @override
  String bottom_modal_duration(int duration_days) {
    return 'Duración: $duration_days';
  }

  @override
  String get bottom_modal_btn => 'Crear';

  @override
  String get calendar_progress => 'Progreso del calendario';

  @override
  String get calendar_informations => 'Información';

  @override
  String get calendar_mark_session => 'Marcar sesión';

  @override
  String get calendar_completed_days => 'días completados';

  @override
  String get calendar_empty_state => 'Ningún objetivo activo';

  @override
  String get calender_empty_state_subtitle =>
      'Crea tu primer objetivo para iniciar tu camino';

  @override
  String get calendar_loading => 'Cargando calendario...';

  @override
  String get objectives_actif => 'Activos';

  @override
  String get objectives_completed => 'Completados';

  @override
  String get objectives_archived => 'Archivados';

  @override
  String get objectives_actif_empty_title => 'Ningún objetivo activo';

  @override
  String get objectives_actif_empty_subtitle =>
      '¡Empieza creando tu primer objetivo!';

  @override
  String get objectives_completed_empty_title => 'Ningún objetivo completado';

  @override
  String get objectives_completed_empty_subtitle =>
      'Completa tus objetivos para verlos aquí';

  @override
  String get objectives_archived_empty_title => 'Ningún objetivo archivado';

  @override
  String get objectives_archived_empty_subtitle =>
      'Archiva tus objetivos para organizarlos';

  @override
  String get objectives_informations => 'Series';

  @override
  String get objectives_informations2 => 'Best';

  @override
  String get badge_earned => 'Última insignia obtenida';

  @override
  String get badge_level => 'Nivel';

  @override
  String get badge1_title => 'Principiante';

  @override
  String get badge2_title => 'Determinado';

  @override
  String get badge3_title => 'Élite';

  @override
  String get badge4_title => 'Maestro';

  @override
  String get badge5_title => 'Campeón';

  @override
  String get badge6_title => 'Leyenda';

  @override
  String get badge7_title => 'Alto rango';

  @override
  String get badge8_title => 'Alto rango';

  @override
  String get badge9_title => 'Trascendente';

  @override
  String get badge1_desc => '¡Bienvenido a tu aventura con HabitoX!';

  @override
  String get badge2_desc => '¡Tu determinación empieza a dar frutos!';

  @override
  String get badge3_desc => '¡Eres uno de nuestros usuarios de élite!';

  @override
  String get badge4_desc => '¡Tu dominio del tema es excepcional!';

  @override
  String get badge5_desc => '¡Eres un verdadero campeón!';

  @override
  String get badge6_desc => '¡Tu leyenda inspira a los demás!';

  @override
  String get badge7_desc => '¡Alcanza el nivel 50 para este logro!';

  @override
  String get badge8_desc => '¡Alcanza el nivel 60 para este logro!';

  @override
  String get badge9_desc => '¡Alcanza el nivel 70 para este logro!';

  @override
  String get upgrade_card_title => 'Mejorar plan ahora';

  @override
  String get upgrade_card_subtitle =>
      'Disfruta de todos los beneficios y explora más posibilidades';

  @override
  String get settings_appearance => 'Apariencia de la app';

  @override
  String get settings_data_analytics => 'Datos y análisis';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_import => 'Importar';

  @override
  String get settings_export => 'Exportar';

  @override
  String get settings_privacy_policy => 'Política de privacidad';

  @override
  String get settings_app_updates => 'Actualizaciones de la app';

  @override
  String get settings_rate_app => 'Valorar la app';

  @override
  String get settings_follow_instagram => 'Seguir en Insta';

  @override
  String get premium_monthly => 'Mensual';

  @override
  String get premium_annual => 'Anual';

  @override
  String get premium_life => 'De por vida';

  @override
  String get premium_subscribe_subtitle =>
      'Facturación recurrente. Cancela en cualquier momento';

  @override
  String get premium_paiement_subtitle =>
      'Paga una vez. Acceso ilimitado para siempre';

  @override
  String get premium_feature_title => 'Al suscribirte, también desbloquearás:';

  @override
  String get premium_feature_title1 => 'Acceso a importaciones y exportaciones';

  @override
  String get premium_feature_title2 => 'Widget en la pantalla de inicio';

  @override
  String get premium_feature_title3 => 'Acceso a gráficos y estadísticas';

  @override
  String get premium_feature_title4 => 'Insignias personalizadas';

  @override
  String get premium_feature_title1_desc =>
      'Respalda o migra tus datos fácilmente';

  @override
  String get premium_feature_title2_desc =>
      'Accede a tus hábitos favoritos desde la pantalla de inicio';

  @override
  String get premium_feature_title3_desc =>
      'Visualiza tus tendencias y constancia';

  @override
  String get premium_feature_title4_desc =>
      'Recompensas únicas adaptadas a tus objetivos';

  @override
  String get premium_btn => 'Continuar';
}
