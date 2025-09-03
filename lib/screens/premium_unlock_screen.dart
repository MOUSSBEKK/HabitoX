import 'package:flutter/material.dart';

class PremiumUnlockScreen extends StatefulWidget {
  const PremiumUnlockScreen({super.key});

  @override
  State<PremiumUnlockScreen> createState() => _PremiumUnlockScreenState();
}

class _PremiumUnlockScreenState extends State<PremiumUnlockScreen> {
  String _selectedPlan = 'Annuel';
  String? _errorMessage;

  // Prix affichés (vous pourrez brancher des valeurs dynamiques/i18n plus tard)
  final String _priceMonthly = '1,99 €';
  final String _priceAnnual = '12,99 €';
  final String _priceAnnualOld = '23,88';
  final String _priceLifetime = '34,99 €';

  @override
  Widget build(BuildContext context) {
    final Color bg = const Color.fromRGBO(226, 239, 243, 1);
    final Color card = const Color(0xFF17181D);
    final Color border = const Color(0xFF2A2B31);
    final Color accent = const Color(0xFF6db399);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        title: const Text('Débloquer HabitoX Premium'),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Continuer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPlansSection(
                bg: bg,
                card: card,
                border: border,
                accent: accent,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _onRestorePurchase,
                  child: const Text(
                    'Déjà abonné ? Rétablir l\'achat',
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildFeaturesCardDark(
                card: card,
                border: border,
                accent: accent,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlansSection({
    required Color bg,
    required Color card,
    required Color border,
    required Color accent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPlanCard(
          title: 'Mensuel',
          price: _priceMonthly,
          selected: _selectedPlan == 'Mensuel',
          onTap: () => setState(() => _selectedPlan = 'Mensuel'),
          card: card,
          border: border,
          accent: accent,
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          title: 'Annuel',
          price: _priceAnnual,
          oldPrice: _priceAnnualOld,
          discountBadge: '-50%',
          selected: _selectedPlan == 'Annuel',
          onTap: () => setState(() => _selectedPlan = 'Annuel'),
          card: card,
          border: border,
          accent: accent,
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Facturation récurrente. Annulez à tout moment.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'ou',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          title: 'A vie',
          price: _priceLifetime,
          selected: _selectedPlan == 'A vie',
          onTap: () => setState(() => _selectedPlan = 'A vie'),
          card: card,
          border: border,
          accent: accent,
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Payez une fois. Accès illimité pour toujours.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 6),
          Center(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Color(0xFFF87171),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    String? oldPrice,
    String? discountBadge,
    required bool selected,
    required VoidCallback onTap,
    required Color card,
    required Color border,
    required Color accent,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? accent : border, width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? accent : Colors.white70,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (discountBadge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            discountBadge,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (oldPrice != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          oldPrice,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white54,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF101114),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCardDark({
    required Color card,
    required Color border,
    required Color accent,
  }) {
    final features = <_FeatureItem>[
      _FeatureItem(
        title: 'Accéder aux import et export',
        subtitle: 'Sauvegardez ou migrez vos données en toute simplicité.',
        icon: Icons.import_export,
        color: const Color(0xFF10B981),
      ),
      _FeatureItem(
        title: "Widget sur l'écran d'accueil",
        subtitle:
            'Accédez à vos habitudes favorites depuis l\'écran d\'accueil.',
        icon: Icons.widgets,
        color: const Color(0xFF3B82F6),
      ),
      _FeatureItem(
        title: 'Accès à des graphiques et statistiques',
        subtitle: 'Visualisez vos tendances et votre régularité.',
        icon: Icons.show_chart,
        color: const Color(0xFFF59E0B),
      ),
      _FeatureItem(
        title: 'Badges personnalisés',
        subtitle: 'Créez des récompenses uniques adaptées à vos objectifs.',
        icon: Icons.emoji_events,
        color: const Color(0xFF8B5CF6),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'En vous abonnant, vous débloquerez également :',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...features.map((f) => _buildFeatureTileDark(f)),
        ],
      ),
    );
  }

  Widget _buildFeatureTileDark(_FeatureItem feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(feature.icon, color: feature.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    color: feature.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onContinue() {
    // Placeholder achat
    setState(() {
      _errorMessage = null; // ou affichez une erreur simulée
    });
    // TODO: intégrer la logique d'achat (StoreKit/Play Billing/Stripe)
  }

  void _onRestorePurchase() {
    // Placeholder restauration
    // TODO: intégrer la restauration des achats
    setState(() {
      _errorMessage =
          "Quelque chose s'est mal passé. Essayez à nouveau plus tard";
    });
  }
}

class _FeatureItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  _FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
