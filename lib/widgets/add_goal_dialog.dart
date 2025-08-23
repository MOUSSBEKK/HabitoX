import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';

class AddGoalDialog extends StatefulWidget {
  final Goal? goal;

  const AddGoalDialog({super.key, this.goal});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
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
      // Mode édition
      _titleController.text = widget.goal!.title;
      _descriptionController.text = widget.goal!.description;
      _targetDaysController.text = widget.goal!.targetDays.toString();
      _selectedIcon = widget.goal!.icon;
      _selectedColor = widget.goal!.color;
      _targetDays = widget.goal!.targetDays;
    } else {
      // Mode création
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre du dialogue
              Row(
                children: [
                  Icon(
                    widget.goal != null ? Icons.edit : Icons.add,
                    color: Colors.indigo,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.goal != null
                        ? 'Modifier l\'objectif'
                        : 'Nouvel objectif',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sélection de l'icône et de la couleur
              _buildIconColorSelector(),

              const SizedBox(height: 20),

              // Champ titre
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre de l\'objectif',
                  hintText: 'Ex: Apprendre la guitare',
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

              // Champ description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Décrivez votre objectif...',
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

              // Champ nombre de jours cible
              TextFormField(
                controller: _targetDaysController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de jours cible',
                  hintText: '30',
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

              const SizedBox(height: 24),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveGoal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(widget.goal != null ? 'Modifier' : 'Créer'),
                    ),
                  ),
                ],
              ),
            ],
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
                        ? color.withOpacity(0.2)
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
        // Mode édition
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
        // Mode création
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

