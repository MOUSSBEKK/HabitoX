import 'package:flutter/material.dart';
import 'dart:math';

/// Widget d'avatar personnalisable avec système d'accessoires
/// Les accessoires se débloquent automatiquement tous les 5 jours consécutifs
class AvatarWidget extends StatelessWidget {
  final int consecutiveDays;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool showAccessories;
  final String? seed; // Pour un positionnement déterministe des accessoires

  const AvatarWidget({
    super.key,
    required this.consecutiveDays,
    this.size = 60.0,
    this.backgroundColor,
    this.iconColor,
    this.showAccessories = true,
    this.seed,
  });

  @override
  Widget build(BuildContext context) {
    final accessories = _getUnlockedAccessories();
    final effectiveSeed = seed ?? consecutiveDays.toString();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Avatar de base (cercle + icône utilisateur)
          _buildBaseAvatar(context),

          // Accessoires superposés
          if (showAccessories && accessories.isNotEmpty)
            ...accessories.map(
              (accessory) => _buildAccessory(accessory, effectiveSeed, context),
            ),
        ],
      ),
    );
  }

  /// Construit l'avatar de base (cercle avec icône utilisateur)
  Widget _buildBaseAvatar(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border.all(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: iconColor ?? Theme.of(context).primaryColor,
      ),
    );
  }

  /// Construit un accessoire avec positionnement déterministe
  Widget _buildAccessory(
    String accessoryType,
    String seed,
    BuildContext context,
  ) {
    final random = Random(seed.hashCode);
    final position = _getAccessoryPosition(accessoryType, random);
    final accessoryWidget = _getAccessoryWidget(accessoryType, context);

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Transform.rotate(
        angle: random.nextDouble() * 0.2 - 0.1, // Légère rotation aléatoire
        child: accessoryWidget,
      ),
    );
  }

  /// Obtient la position d'un accessoire basée sur son type et un seed
  Offset _getAccessoryPosition(String accessoryType, Random random) {
    final baseSize = size;

    switch (accessoryType) {
      case 'hat':
        return Offset(
          baseSize * 0.1 + random.nextDouble() * baseSize * 0.1,
          -baseSize * 0.1,
        );
      case 'glasses':
        return Offset(
          baseSize * 0.2 + random.nextDouble() * baseSize * 0.1,
          baseSize * 0.3 + random.nextDouble() * baseSize * 0.1,
        );
      case 'star':
        return Offset(
          baseSize * 0.7 + random.nextDouble() * baseSize * 0.1,
          baseSize * 0.1 + random.nextDouble() * baseSize * 0.1,
        );
      case 'crown':
        return Offset(
          baseSize * 0.05 + random.nextDouble() * baseSize * 0.1,
          -baseSize * 0.15,
        );
      case 'wings':
        return Offset(
          -baseSize * 0.1 + random.nextDouble() * baseSize * 0.05,
          baseSize * 0.2 + random.nextDouble() * baseSize * 0.1,
        );
      case 'halo':
        return Offset(
          baseSize * 0.1 + random.nextDouble() * baseSize * 0.1,
          -baseSize * 0.2,
        );
      case 'rainbow':
        return Offset(
          baseSize * 0.6 + random.nextDouble() * baseSize * 0.1,
          baseSize * 0.05 + random.nextDouble() * baseSize * 0.1,
        );
      case 'fire':
        return Offset(
          baseSize * 0.8 + random.nextDouble() * baseSize * 0.1,
          baseSize * 0.4 + random.nextDouble() * baseSize * 0.1,
        );
      case 'ice':
        return Offset(
          -baseSize * 0.05 + random.nextDouble() * baseSize * 0.05,
          baseSize * 0.6 + random.nextDouble() * baseSize * 0.1,
        );
      case 'lightning':
        return Offset(
          baseSize * 0.75 + random.nextDouble() * baseSize * 0.1,
          baseSize * 0.2 + random.nextDouble() * baseSize * 0.1,
        );
      default:
        return Offset(
          random.nextDouble() * baseSize * 0.2,
          random.nextDouble() * baseSize * 0.2,
        );
    }
  }

  /// Obtient le widget correspondant à un type d'accessoire
  Widget _getAccessoryWidget(String accessoryType, BuildContext context) {
    final accessorySize = size * 0.3;

    switch (accessoryType) {
      case 'hat':
        return Icon(
          Icons.emoji_events,
          size: accessorySize,
          color: Colors.amber[600],
        );
      case 'glasses':
        return Icon(
          Icons.visibility,
          size: accessorySize,
          color: Colors.blue[600],
        );
      case 'star':
        return Icon(Icons.star, size: accessorySize, color: Colors.yellow[600]);
      case 'crown':
        return Icon(
          Icons.workspace_premium,
          size: accessorySize,
          color: Colors.purple[600],
        );
      case 'wings':
        return Icon(Icons.flight, size: accessorySize, color: Colors.white);
      case 'halo':
        return Icon(
          Icons.brightness_1,
          size: accessorySize,
          color: Colors.yellow[300],
        );
      case 'rainbow':
        return Icon(
          Icons.auto_awesome,
          size: accessorySize,
          color: Colors.pink[400],
        );
      case 'fire':
        return Icon(
          Icons.local_fire_department,
          size: accessorySize,
          color: Colors.red[600],
        );
      case 'ice':
        return Icon(
          Icons.ac_unit,
          size: accessorySize,
          color: Colors.cyan[400],
        );
      case 'lightning':
        return Icon(Icons.bolt, size: accessorySize, color: Colors.amber[700]);
      default:
        return Icon(
          Icons.auto_awesome,
          size: accessorySize,
          color: Colors.grey[600],
        );
    }
  }

  /// Obtient la liste des accessoires débloqués basés sur les jours consécutifs
  List<String> _getUnlockedAccessories() {
    final accessories = <String>[];

    // Débloquer un accessoire tous les 5 jours consécutifs
    for (int i = 5; i <= consecutiveDays; i += 5) {
      accessories.add(_getAccessoryForDays(i));
    }

    return accessories;
  }

  /// Obtient l'accessoire correspondant à un nombre de jours
  String _getAccessoryForDays(int days) {
    final accessories = [
      'hat', // 5 jours
      'glasses', // 10 jours
      'star', // 15 jours
      'crown', // 20 jours
      'wings', // 25 jours
      'halo', // 30 jours
      'rainbow', // 35 jours
      'fire', // 40 jours
      'ice', // 45 jours
      'lightning', // 50 jours
    ];

    final index = (days ~/ 5) - 1;
    if (index >= 0 && index < accessories.length) {
      return accessories[index];
    }

    // Pour les jours très élevés, répéter les accessoires
    return accessories[index % accessories.length];
  }
}

/// Widget d'avatar avec animation de déblocage d'accessoire
class AnimatedAvatarWidget extends StatefulWidget {
  final int consecutiveDays;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? seed;

  const AnimatedAvatarWidget({
    super.key,
    required this.consecutiveDays,
    this.size = 60.0,
    this.backgroundColor,
    this.iconColor,
    this.seed,
  });

  @override
  State<AnimatedAvatarWidget> createState() => _AnimatedAvatarWidgetState();
}

class _AnimatedAvatarWidgetState extends State<AnimatedAvatarWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  int _previousConsecutiveDays = 0;

  @override
  void initState() {
    super.initState();
    _previousConsecutiveDays = widget.consecutiveDays;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Détecter si un nouvel accessoire a été débloqué
    if (widget.consecutiveDays > _previousConsecutiveDays) {
      final newAccessories = _getNewAccessories();
      if (newAccessories.isNotEmpty) {
        _triggerUnlockAnimation();
      }
      _previousConsecutiveDays = widget.consecutiveDays;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerUnlockAnimation() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  List<String> _getNewAccessories() {
    final currentAccessories = _getUnlockedAccessories(widget.consecutiveDays);
    final previousAccessories = _getUnlockedAccessories(
      _previousConsecutiveDays,
    );

    return currentAccessories
        .where((accessory) => !previousAccessories.contains(accessory))
        .toList();
  }

  List<String> _getUnlockedAccessories(int days) {
    final accessories = <String>[];

    for (int i = 5; i <= days; i += 5) {
      accessories.add(_getAccessoryForDays(i));
    }

    return accessories;
  }

  String _getAccessoryForDays(int days) {
    final accessories = [
      'hat',
      'glasses',
      'star',
      'crown',
      'wings',
      'halo',
      'rainbow',
      'fire',
      'ice',
      'lightning',
    ];

    final index = (days ~/ 5) - 1;
    if (index >= 0 && index < accessories.length) {
      return accessories[index];
    }

    return accessories[index % accessories.length];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: AvatarWidget(
              consecutiveDays: widget.consecutiveDays,
              size: widget.size,
              backgroundColor: widget.backgroundColor,
              iconColor: widget.iconColor,
              seed: widget.seed,
            ),
          ),
        );
      },
    );
  }
}

