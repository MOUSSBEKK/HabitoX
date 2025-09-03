import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AppAppearanceScreen extends StatefulWidget {
  const AppAppearanceScreen({super.key});

  @override
  State<AppAppearanceScreen> createState() => _AppAppearanceScreenState();
}

class _AppAppearanceScreenState extends State<AppAppearanceScreen> {
  String _selectedTheme = 'system';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thème',
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildThemeSection(),
            ],
          ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return _buildSection(
      children: [
        _buildThemeOption('Automatique', 'system', Icons.brightness_auto),
        _buildThemeOption('Clair', 'light', Icons.light_mode),
        _buildThemeOption('Sombre', 'dark', Icons.dark_mode),
      ],
    );
  }

 
  Widget _buildSection({required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              ? Color.fromRGBO(167, 198, 165, 0.2)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FaIcon(
          icon, 
          color: isSelected ? Color(0xFFA7C6A5) : Colors.grey.shade600,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isSelected ? Color(0xFFA7C6A5) : null,
        ),
      ),
      trailing: isSelected 
          ? Icon(Icons.check_circle, color: Color(0xFFA7C6A5))
          : null,
      onTap: () {
        setState(() {
          _selectedTheme = value;
        });
      },
    );
  }

}
