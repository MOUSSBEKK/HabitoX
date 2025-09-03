import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';

class AddGoalBottomSheetColors {
  static const Color primaryColor = Color(0xFFA7C6A5);
  static const Color lightColor = Color(0xFF85B8CB);
  static const Color darkColor = Color(0xFF1F4843);

  // Palette de couleurs pour les objectifs (inspirée de l'image fournie) - Limitée à 15 couleurs
  static const List<Color> goalColors = [
    Color(0xFFFFF8B4), // Jaune clair
    Color(0xFFFFB380), // Orange clair
    Color(0xFF8B7B8B), // Violet gris
    Color(0xFFCF9FCA), // Rose violet
    Color(0xFFFF8A9B), // Rose saumon
    Color(0xFFFFC0CB), // Rose
    Color(0xFFFF69B4), // Rose vif
    Color(0xFF98FB98), // Vert clair
    Color(0xFF9370DB), // Violet moyen
    Color(0xFFC8A2C8), // Lilas
    Color(0xFF87CEEB), // Bleu ciel
    Color(0xFF5F9EA0), // Cadet bleu
    Color(0xFFB0E0E6), // Bleu poudre
    Color(0xFF32CD32), // Vert lime
    Color(0xFFFFE4B5), // Pêche
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
      color: Colors.white,
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
                            ? 'Modifier l\'objectif'
                            : 'Nouvel objectif',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AddGoalBottomSheetColors.darkColor,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
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
                    decoration: const InputDecoration(
                      labelText: 'Titre de l\'objectif',
                      hintText: 'Ex: Apprendre la guitare',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      prefixIcon: Icon(Icons.flag),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir un titre';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Décrivez votre objectif...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir une description';
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
                            backgroundColor:
                                AddGoalBottomSheetColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            widget.goal != null ? 'Modifier' : 'Créer',
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
    // Icônes principales à afficher dans la ligne
    final baseIcons = [
      Icons.fitness_center,
      Icons.music_note,
      Icons.book,
      Icons.code,
      Icons.language,
      Icons.brush,
    ];

    // Organiser les icônes pour mettre la sélectionnée en premier
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
              'Icône',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            GestureDetector(
              onTap: _showAllIconsModal,
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AddGoalBottomSheetColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AddGoalBottomSheetColors.primaryColor,
                  ),
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
                              ? AddGoalBottomSheetColors.primaryColor
                                    .withValues(alpha: 0.2)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: icon == _selectedIcon
                                ? AddGoalBottomSheetColors.primaryColor
                                : Colors.grey[300]!,
                            width: icon == _selectedIcon ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: icon == _selectedIcon
                              ? AddGoalBottomSheetColors.primaryColor
                              : Colors.grey[600],
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
    final mainColors = AddGoalBottomSheetColors.goalColors.take(8).toList();

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
              'Couleur',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            GestureDetector(
              onTap: _showAllColorsModal,
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AddGoalBottomSheetColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AddGoalBottomSheetColors.primaryColor,
                  ),
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
                      height: 40,
                      width: 40,
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
                          ? const Icon(
                              Icons.check,
                              color: Color.fromARGB(255, 29, 29, 29),
                              size: 16,
                            )
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
      children: [
        // Date de début
        GestureDetector(
          onTap: () => _selectStartDate(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date de début',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _startDate != null
                          ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                          : 'Sélectionner une date',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Date de fin
        GestureDetector(
          onTap: () => _selectEndDate(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.event, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date de fin',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _endDate != null
                          ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                          : 'Sélectionner une date',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Affichage du nombre de jours calculé
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AddGoalBottomSheetColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Durée: $_calculatedDays jours',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AddGoalBottomSheetColors.darkColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
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
      context: context,
      initialDate:
          _endDate ??
          (_startDate?.add(const Duration(days: 30)) ??
              DateTime.now().add(const Duration(days: 30))),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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

  // Toutes les icônes disponibles
  static final List<IconData> allIcons = [
    // Sports & Fitness
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

    // Arts & Creativity
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

    // Learning & Education
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

    // Technology & Work
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

    // Health & Wellness
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

    // Food & Cooking
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

    // Travel & Adventure
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

    // Goals & Achievement
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

    // Social & Relationships
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

    // Hobbies & Interests
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
  ];

  void _showAllIconsModal() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _buildAllIconsModal(),
    );
  }

  Widget _buildAllIconsModal() {
    // Organiser les icônes pour mettre la sélectionnée en premier
    final orderedIcons = <IconData>[];
    if (allIcons.contains(_selectedIcon)) {
      orderedIcons.add(_selectedIcon);
      orderedIcons.addAll(allIcons.where((icon) => icon != _selectedIcon));
    } else {
      orderedIcons.addAll(allIcons);
    }

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choisir une icône',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AddGoalBottomSheetColors.darkColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: ModalScrollController.of(context),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: orderedIcons.length,
                  itemBuilder: (context, index) {
                    final icon = orderedIcons[index];
                    final isSelected = icon == _selectedIcon;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AddGoalBottomSheetColors.primaryColor
                                    .withValues(alpha: 0.2)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AddGoalBottomSheetColors.primaryColor
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? AddGoalBottomSheetColors.primaryColor
                              : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
                    'Choisir une couleur',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AddGoalBottomSheetColors.darkColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
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
                          ? const Icon(
                              Icons.check,
                              color: Color.fromARGB(255, 51, 51, 51),
                              size: 20,
                            )
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
          icon: _selectedIcon,
          color: _selectedColor,
          targetDays: _calculatedDays,
          lastUpdated: DateTime.now(),
        );

        goalService.updateGoal(updatedGoal);
        toastification.show(
          context: context,
          title: const Text('Objectif modifié avec succès !'),
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        final newGoal = Goal(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          icon: _selectedIcon,
          color: _selectedColor,
          targetDays: _calculatedDays,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
        );

        goalService.addGoal(newGoal);
        toastification.show(
          context: context,
          title: const Text('Objectif créé avec succès !'),
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }

      Navigator.pop(context);
    }
  }
}
