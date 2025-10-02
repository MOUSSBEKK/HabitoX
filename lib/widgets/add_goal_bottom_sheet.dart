import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../l10n/app_localizations.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class AddGoalBottomSheetColors {
  static const Color primaryColor = Color(
    0xFF2E7D32,
  ); // Vert plus foncé et visible
  static const Color lightColor = Color(0xFF85B8CB);
  static const Color darkColor = Color(0xFF1F4843);

  // Palette de couleurs pour les objectifs - Couleurs avec bonne lisibilité
  static const List<Color> goalColors = [
    Color(0xFFFF8C00), // Orange vif
    Color(0xFF8B7B8B), // Violet gris
    Color(0xFFCF9FCA), // Rose violet
    Color(0xFFFF8A9B), // Rose saumon
    Color(0xFFFF69B4), // Rose vif
    Color(0xFF9370DB), // Violet moyen
    Color.fromARGB(255, 224, 141, 224), // Lilas
    Color(0xFF4169E1), // Bleu royal
    Color(0xFF5F9EA0), // Cadet bleu
    Color(0xFF20B2AA), // Turquoise
    Color(0xFF32CD32), // Vert lime
    Color(0xFF228B22), // Vert forêt
    Color(0xFFDC143C), // Rouge cramoisi
    Color(0xFF8B0000), // Rouge foncé
    Color(0xFF4B0082), // Indigo
  ];
}

class AddGoalBottomSheet extends StatefulWidget {
  final Goal? goal;

  const AddGoalBottomSheet({super.key, this.goal});

  @override
  State<AddGoalBottomSheet> createState() => _AddGoalBottomSheetState();
}

class _AddGoalBottomSheetState extends State<AddGoalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late IconData _selectedIcon;
  late Color _selectedColor;
  DateTime? _startDate;
  DateTime? _endDate;
  int _calculatedDays = 30;

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _titleController.text = widget.goal!.title;
      _descriptionController.text = widget.goal!.description;
      _selectedIcon = widget.goal!.icon;
      _selectedColor = widget.goal!.color;
      _calculatedDays = widget.goal!.targetDays;
      // TODO: Ajouter les champs startDate et endDate au modèle Goal
      _startDate = widget.goal!.createdAt; // Temporaire
      _endDate = widget.goal!.createdAt.add(
        Duration(days: widget.goal!.targetDays),
      ); // Temporaire
    } else {
      _selectedIcon = Icons.flag; // Icône par défaut
      _selectedColor = AddGoalBottomSheetColors.goalColors.first;
      _calculatedDays = 30;
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 30));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Material(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: mediaQuery.viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.goal != null
                            ? AppLocalizations.of(context)!.bottom_modal_title2
                            : AppLocalizations.of(context)!.bottom_modal_title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(HugeIconsStroke.cancel01, size: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildIconSelector(),

                  const SizedBox(height: 24),

                  _buildColorSelector(),

                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _titleController,
                    maxLength: 25,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.bottom_modal_input_title,
                      helperStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      hintText: AppLocalizations.of(
                        context,
                      )!.bottom_modal_placeholder_title,
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.bottom_modal_error_title;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    maxLength: 100,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.bottom_modal_input_desc,
                      labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      helperStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      hintText: AppLocalizations.of(
                        context,
                      )!.bottom_modal_placeholder_desc,
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      focusColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primary,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        ),
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.bottom_modal_error_desc;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildDateFields(),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveGoal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.goal != null
                                ? AppLocalizations.of(
                                    context,
                                  )!.bottom_modal_btn2
                                : AppLocalizations.of(
                                    context,
                                  )!.bottom_modal_btn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    final baseIcons = [
      Icons.fitness_center,
      Icons.music_note,
      Icons.book,
      Icons.code,
      Icons.language,
      Icons.brush,
    ];

    final mainIcons = <IconData>[];
    if (baseIcons.contains(_selectedIcon)) {
      mainIcons.add(_selectedIcon);
      mainIcons.addAll(baseIcons.where((icon) => icon != _selectedIcon));
    } else {
      // Si l'icône sélectionnée n'est pas dans la liste de base, l'ajouter en premier
      mainIcons.add(_selectedIcon);
      mainIcons.addAll(baseIcons.take(5)); // Prendre seulement 5 icônes de base
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.bottom_modal_icon,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            GestureDetector(
              onTap: _showAllIconsModal,
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.bottom_modal_view,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  Icon(HugeIconsStroke.arrowRight01, size: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: Row(
            children: [
              ...mainIcons.map(
                (icon) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: icon == _selectedIcon
                              ? Theme.of(
                                  context,
                                ).colorScheme.secondary.withValues(alpha: 0.2)
                              : Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: icon == _selectedIcon
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey[300]!,
                            width: icon == _selectedIcon ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: icon == _selectedIcon
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).iconTheme.color,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    // Couleurs principales à afficher dans la ligne
    final mainColors = AddGoalBottomSheetColors.goalColors.take(6).toList();

    // Organiser les couleurs pour mettre la sélectionnée en premier
    final orderedMainColors = <Color>[];
    if (mainColors.contains(_selectedColor)) {
      orderedMainColors.add(_selectedColor);
      orderedMainColors.addAll(
        mainColors.where((color) => color != _selectedColor),
      );
    } else {
      // Si la couleur sélectionnée n'est pas dans la liste principale, l'ajouter en premier
      orderedMainColors.add(_selectedColor);
      orderedMainColors.addAll(
        mainColors.take(4),
      ); // Prendre seulement 4 couleurs principales
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.bottom_modal_color,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            GestureDetector(
              onTap: _showAllColorsModal,
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.bottom_modal_view,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  Icon(HugeIconsStroke.arrowRight01, size: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              ...orderedMainColors.map(
                (color) => Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color == _selectedColor
                              ? AddGoalBottomSheetColors.darkColor
                              : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: color == _selectedColor
                          ? const Icon(Icons.check, size: 16)
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre "Date range"
        Text(
          'Date range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        // Sélecteurs de date côte à côte
        Row(
          children: [
            // Date de début
            Expanded(
              child: _buildDatePickerField(
                label: AppLocalizations.of(
                  context,
                )!.bottom_modal_input_start_date,
                date: _startDate,
                onTap: () => _selectStartDate(),
              ),
            ),
            const SizedBox(width: 12),
            // Date de fin
            Expanded(
              child: _buildDatePickerField(
                label: AppLocalizations.of(
                  context,
                )!.bottom_modal_input_start_end,
                date: _endDate,
                onTap: () => _selectEndDate(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date != null ? _formatDate(date) : 'Select a date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: date != null
                          ? Theme.of(context).textTheme.bodyMedium?.color
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} - ${date.month.toString().padLeft(2, '0')} - ${date.year}';
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
            onPrimary: Colors.black,
            surface: Theme.of(context).colorScheme.surface,
            onSurface:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
          ),
        ),
        child: child!,
      ),
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = picked.add(const Duration(days: 1));
        }
        _calculateDays();
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
            onPrimary: Colors.black,
            surface: Theme.of(context).colorScheme.surface,
            onSurface:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
          ),
        ),
        child: child!,
      ),
      context: context,
      initialDate:
          _endDate ??
          (_startDate?.add(const Duration(days: 30)) ??
              DateTime.now().add(const Duration(days: 30))),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      cancelText: AppLocalizations.of(context)!.cancel,
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _calculateDays();
      });
    }
  }

  void _calculateDays() {
    if (_startDate != null && _endDate != null) {
      final difference = _endDate!.difference(_startDate!).inDays + 1;
      setState(() {
        _calculatedDays = difference > 0 ? difference : 1;
      });
    }
  }

  // Catégories d'icônes (affichage par blocs)
  static final Map<String, List<IconData>> iconCategories = {
    'Sports & Fitness': [
      Icons.fitness_center,
      Icons.sports_soccer,
      Icons.sports_basketball,
      Icons.sports_tennis,
      Icons.sports_volleyball,
      Icons.sports_football,
      Icons.sports_baseball,
      Icons.sports_hockey,
      Icons.sports_golf,
      Icons.sports_motorsports,
      Icons.sports_esports,
      Icons.pool,
      Icons.snowboarding,
      Icons.surfing,
      Icons.skateboarding,
    ],
    'Arts & Creativity': [
      Icons.brush,
      Icons.palette,
      Icons.music_note,
      Icons.piano,
      Icons.mic,
      Icons.headphones,
      Icons.camera,
      Icons.camera_alt,
      Icons.video_camera_back,
      Icons.theater_comedy,
      Icons.movie,
      Icons.photo,
      Icons.draw,
      Icons.colorize,
    ],
    'Learning & Education': [
      Icons.book,
      Icons.school,
      Icons.science,
      Icons.biotech,
      Icons.psychology,
      Icons.calculate,
      Icons.language,
      Icons.translate,
      Icons.history_edu,
      Icons.menu_book,
      Icons.library_books,
      Icons.quiz,
      Icons.assignment,
      Icons.edit,
      Icons.article,
    ],
    'Technology & Work': [
      Icons.code,
      Icons.computer,
      Icons.laptop,
      Icons.smartphone,
      Icons.web,
      Icons.developer_mode,
      Icons.bug_report,
      Icons.settings,
      Icons.build,
      Icons.work,
      Icons.business,
      Icons.slideshow,
      Icons.analytics,
      Icons.trending_up,
      Icons.monetization_on,
    ],
    'Health & Wellness': [
      Icons.health_and_safety,
      Icons.medical_services,
      Icons.medication,
      Icons.local_hospital,
      Icons.healing,
      Icons.spa,
      Icons.self_improvement,
      Icons.favorite,
      Icons.mood,
      Icons.sentiment_very_satisfied,
      Icons.nights_stay,
      Icons.wb_sunny,
      Icons.eco,
      Icons.nature,
      Icons.park,
    ],
    'Food & Cooking': [
      Icons.restaurant,
      Icons.local_restaurant,
      Icons.food_bank,
      Icons.cake,
      Icons.coffee,
      Icons.local_cafe,
      Icons.local_bar,
      Icons.kitchen,
      Icons.soup_kitchen,
      Icons.ramen_dining,
      Icons.lunch_dining,
      Icons.dinner_dining,
      Icons.breakfast_dining,
      Icons.fastfood,
      Icons.local_pizza,
    ],
    'Travel & Adventure': [
      Icons.flight,
      Icons.train,
      Icons.directions_car,
      Icons.directions_bike,
      Icons.hiking,
      Icons.terrain,
      Icons.map,
      Icons.explore,
      Icons.public,
      Icons.location_on,
      Icons.camera_outdoor,
      Icons.hotel,
      Icons.beach_access,
      Icons.forest,
      Icons.landscape,
    ],
    'Goals & Achievement': [
      Icons.flag,
      Icons.star,
      Icons.emoji_events,
      Icons.military_tech,
      Icons.workspace_premium,
      Icons.diamond,
      Icons.toll,
      Icons.verified,
      Icons.new_releases,
      Icons.trending_up,
      Icons.whatshot,
      Icons.flash_on,
      Icons.bolt,
      Icons.rocket_launch,
      Icons.celebration,
    ],
    'Social & Relationships': [
      Icons.people,
      Icons.group,
      Icons.family_restroom,
      Icons.child_care,
      Icons.elderly,
      Icons.volunteer_activism,
      Icons.handshake,
      Icons.diversity_1,
      Icons.diversity_2,
      Icons.diversity_3,
      Icons.forum,
      Icons.chat,
      Icons.call,
      Icons.video_call,
      Icons.share,
    ],
    'Hobbies & Interests': [
      Icons.games,
      Icons.casino,
      Icons.toys,
      Icons.extension,
      Icons.auto_stories,
      Icons.collections_bookmark,
      Icons.inventory,
      Icons.shopping_cart,
      Icons.local_florist,
      Icons.pets,
      Icons.cruelty_free,
      Icons.grass,
      Icons.agriculture,
      Icons.yard,
    ],
  };

  void _showAllIconsModal() {
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (context) => _buildAllIconsModal(),
    );
  }

  Widget _buildAllIconsModal() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Material(
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: ModalScrollController.of(context),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.bottom_modal_icon_title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(HugeIconsStroke.cancel01),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...iconCategories.entries.map((entry) {
                    final String category = entry.key;
                    final List<IconData> icons = entry.value;

                    // Organiser les icônes pour mettre la sélectionnée en premier dans la catégorie
                    final List<IconData> ordered = icons.contains(_selectedIcon)
                        ? [
                            _selectedIcon,
                            ...icons.where((i) => i != _selectedIcon),
                          ]
                        : List<IconData>.from(icons);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                          GridView.builder(
                            key: ValueKey(
                              _selectedIcon,
                            ), // Force la reconstruction quand l'icône change
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: ordered.length,
                            itemBuilder: (context, index) {
                              final icon = ordered[index];
                              final isSelected = icon == _selectedIcon;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIcon = icon;
                                  });
                                  setModalState(() {
                                    // Force la reconstruction de la modal
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withValues(alpha: 0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.secondary
                                          : Colors.grey[300]!,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Icon(
                                    icon,
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.secondary
                                        : Theme.of(context).iconTheme.color,
                                    size: 24,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAllColorsModal() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _buildAllColorsModal(),
    );
  }

  Widget _buildAllColorsModal() {
    // Organiser les couleurs pour mettre la sélectionnée en premier
    final orderedColors = <Color>[];
    if (AddGoalBottomSheetColors.goalColors.contains(_selectedColor)) {
      orderedColors.add(_selectedColor);
      orderedColors.addAll(
        AddGoalBottomSheetColors.goalColors.where(
          (color) => color != _selectedColor,
        ),
      );
    } else {
      orderedColors.addAll(AddGoalBottomSheetColors.goalColors);
    }

    return Material(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.bottom_modal_color_title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AddGoalBottomSheetColors.darkColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(HugeIconsStroke.cancel01),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: orderedColors.length,
                itemBuilder: (context, index) {
                  final color = orderedColors[index];
                  final isSelected = color == _selectedColor;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AddGoalBottomSheetColors.darkColor
                              : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 25)
                          : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final goalService = context.read<GoalService>();

      if (widget.goal != null) {
        final updatedGoal = widget.goal!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          iconCodePoint: _selectedIcon.codePoint,
          iconFontFamily: _selectedIcon.fontFamily,
          iconFontPackage: _selectedIcon.fontPackage,
          color: _selectedColor,
          targetDays: _calculatedDays,
          lastUpdated: DateTime.now(),
        );

        goalService.updateGoal(updatedGoal, context);
        toastification.show(
          context: context,
          title: Text(AppLocalizations.of(context)!.bottom_modal_modal_succes),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        final newGoal = Goal(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          iconCodePoint: _selectedIcon.codePoint,
          iconFontFamily: _selectedIcon.fontFamily,
          iconFontPackage: _selectedIcon.fontPackage,
          color: _selectedColor,
          targetDays: _calculatedDays,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
        );

        goalService.addGoal(newGoal);
        toastification.show(
          context: context,
          title: Text(AppLocalizations.of(context)!.bottom_modal_modal_created),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }

      Navigator.pop(context);
    }
  }
}
