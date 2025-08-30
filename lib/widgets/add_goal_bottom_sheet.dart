import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';

class AddGoalBottomSheetColors {
  static const Color primaryColor = Color(0xFFA7C6A5);
  static const Color lightColor = Color(0xFF85B8CB);
  static const Color darkColor = Color(0xFF1F4843);
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
  final _targetDaysController = TextEditingController();

  late IconData _selectedIcon;
  late Color _selectedColor;
  late int _targetDays;

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _titleController.text = widget.goal!.title;
      _descriptionController.text = widget.goal!.description;
      _targetDaysController.text = widget.goal!.targetDays.toString();
      _selectedIcon = widget.goal!.icon;
      _selectedColor = widget.goal!.color;
      _targetDays = widget.goal!.targetDays;
    } else {
      _selectedIcon = GoalService.predefinedIcons.first['icon'];
      _selectedColor = GoalService.predefinedIcons.first['color'];
      _targetDays = 30;
      _targetDaysController.text = '30';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.80,
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: mediaQuery.viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.all(12),
                        //   decoration: BoxDecoration(
                        //     color: AddGoalBottomSheetColors.primaryColor
                        //         .withValues(alpha: 0.15),
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: Icon(
                        //     widget.goal != null ? Icons.edit : Icons.add,
                        //     color: AddGoalBottomSheetColors.primaryColor,
                        //     size: 24,
                        //   ),
                        // ),
                        // const SizedBox(width: 16),
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

                    _buildIconColorSelector(),

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

                    TextFormField(
                      controller: _targetDaysController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de jours cible',
                        hintText: '30',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez saisir un nombre de jours';
                        }
                        final days = int.tryParse(value);
                        if (days == null || days <= 0) {
                          return 'Veuillez saisir un nombre valide';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _targetDays = int.tryParse(value) ?? 30;
                      },
                    ),

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
      ),
    );
  }

  Widget _buildIconColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisissez une icône et une couleur',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: GoalService.predefinedIcons.length,
            itemBuilder: (context, index) {
              final iconData = GoalService.predefinedIcons[index];
              final icon = iconData['icon'] as IconData;
              final color = iconData['color'] as Color;
              final isSelected =
                  icon == _selectedIcon && color == _selectedColor;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = icon;
                    _selectedColor = color;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.2)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              );
            },
          ),
        ),
      ],
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
          targetDays: _targetDays,
          lastUpdated: DateTime.now(),
        );

        goalService.updateGoal(updatedGoal);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Objectif modifié avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final newGoal = Goal(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          icon: _selectedIcon,
          color: _selectedColor,
          targetDays: _targetDays,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
        );

        goalService.addGoal(newGoal);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Objectif créé avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pop(context);
    }
  }
}
