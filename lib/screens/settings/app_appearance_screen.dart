import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppAppearanceScreen extends StatefulWidget {
  const AppAppearanceScreen({super.key});

  @override
  State<AppAppearanceScreen> createState() => _AppAppearanceScreenState();
}

class _AppAppearanceScreenState extends State<AppAppearanceScreen> {
  String _selectedTheme = 'system';
  String _selectedLanguage = 'français';
  bool _animationsEnabled = true;
  bool _hapticFeedback = true;
  double _textSize = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apparence de l\'App',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.greenAccent,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(226, 239, 243, 1),
        foregroundColor: Colors.greenAccent,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildThemeSection(),
              const SizedBox(height: 24),
              _buildDisplaySection(),
              const SizedBox(height: 24),
              _buildInteractionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return _buildSection(
      title: 'Thème',
      children: [
        _buildThemeOption('Automatique', 'system', Icons.brightness_auto),
        _buildThemeOption('Clair', 'light', Icons.light_mode),
        _buildThemeOption('Sombre', 'dark', Icons.dark_mode),
      ],
    );
  }

  Widget _buildDisplaySection() {
    return _buildSection(
      title: 'Affichage',
      children: [
        _buildLanguageSelector(),
        const Divider(height: 1),
        _buildTextSizeSlider(),
        const Divider(height: 1),
        _buildColorPreview(),
      ],
    );
  }

  Widget _buildInteractionSection() {
    return _buildSection(
      title: 'Interactions',
      children: [
        _buildSwitchTile(
          icon: Icons.animation,
          title: 'Animations',
          subtitle: 'Activer les animations de l\'interface',
          value: _animationsEnabled,
          onChanged: (value) {
            setState(() {
              _animationsEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          icon: Icons.vibration,
          title: 'Retour haptique',
          subtitle: 'Vibrations lors des interactions',
          value: _hapticFeedback,
          onChanged: (value) {
            setState(() {
              _hapticFeedback = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1 && children[i] is! Divider)
                  Divider(height: 1, color: Colors.grey.shade200),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(String title, String value, IconData icon) {
    final isSelected = _selectedTheme == value;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon, 
          color: isSelected ? AppColors.primaryColor : Colors.grey.shade600,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isSelected ? AppColors.primaryColor : null,
        ),
      ),
      trailing: isSelected 
          ? Icon(Icons.check_circle, color: AppColors.primaryColor)
          : null,
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
      },
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.language, color: AppColors.primaryColor),
      ),
      title: const Text(
        'Langue',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        _selectedLanguage,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageDialog(),
    );
  }

  Widget _buildTextSizeSlider() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.text_fields, color: AppColors.primaryColor),
              ),
              const SizedBox(width: 12),
              const Text(
                'Taille du texte',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Aa', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _textSize,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  activeColor: AppColors.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _textSize = value;
                    });
                  },
                ),
              ),
              const Text('Aa', style: TextStyle(fontSize: 18)),
            ],
          ),
          Text(
            'Exemple de texte',
            style: TextStyle(fontSize: 16 * _textSize),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPreview() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.palette, color: AppColors.primaryColor),
              ),
              const SizedBox(width: 12),
              const Text(
                'Couleurs de l\'app',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildColorSwatch('Principal', AppColors.primaryColor),
              const SizedBox(width: 12),
              _buildColorSwatch('Secondaire', Colors.blue),
              const SizedBox(width: 12),
              _buildColorSwatch('Sombre', AppColors.darkColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryColor,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Français', 'français'),
            _buildLanguageOption('English', 'anglais'),
            _buildLanguageOption('Español', 'espagnol'),
            _buildLanguageOption('Deutsch', 'allemand'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String title, String value) {
    final isSelected = _selectedLanguage == value;
    
    return ListTile(
      title: Text(title),
      trailing: isSelected 
          ? Icon(Icons.check, color: AppColors.primaryColor)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
        Navigator.pop(context);
      },
    );
  }
}
