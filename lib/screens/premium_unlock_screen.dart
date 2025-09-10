import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';

class PremiumUnlockScreen extends StatefulWidget {
  const PremiumUnlockScreen({super.key});

  @override
  State<PremiumUnlockScreen> createState() => _PremiumUnlockScreenState();
}

class _PremiumUnlockScreenState extends State<PremiumUnlockScreen> {
  String _selectedPlan = 'Annuel';
  String? _errorMessage;

  // ! KIWI a changer
  final String _priceMonthly = '1,99 €';
  final String _priceAnnual = '12,99 €';
  final String _priceAnnualOld = '23,88';
  final String _priceLifetime = '34,99 €';

  @override
  Widget build(BuildContext context) {
    final Color bg = Theme.of(context).colorScheme.surface;
    final Color card = Theme.of(context).colorScheme.primary;
    final Color border = AppColors.borderColorLight;
    final Color accent = const Color(0xFF6db399);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: AppColors.darkColor,
        title: Text(
          'HabitoX Premium',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6db399),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.premium_btn,
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
              const SizedBox(height: 24),
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
          title: AppLocalizations.of(context)!.premium_monthly,
          price: _priceMonthly,
          selected: _selectedPlan == 'Mensuel',
          onTap: () => setState(() => _selectedPlan = 'Mensuel'),
          card: card,
          border: border,
          accent: accent,
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          title: AppLocalizations.of(context)!.premium_annual,
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
            AppLocalizations.of(context)!.premium_subscribe_subtitle,
            style: TextStyle(
              color: AppColors.darkColor.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'or',
            style: TextStyle(
              color: AppColors.darkColor.withOpacity(0.9),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildPlanCard(
          title: AppLocalizations.of(context)!.premium_life,
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
            AppLocalizations.of(context)!.premium_paiement_subtitle,
            style: TextStyle(
              color: AppColors.darkColor.withOpacity(0.8),
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
              color: selected ? accent : Colors.grey,
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
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
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
                            color: Color(0xFFA7C6A5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            discountBadge,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
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
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_right_alt,
                          color: Theme.of(
                            context,
                          ).iconTheme.color?.withOpacity(0.45),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          price,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
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
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Text(
                price,
                style: const TextStyle(
                  color: AppColors.darkColor,
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
        title: AppLocalizations.of(context)!.premium_feature_title1,
        subtitle: AppLocalizations.of(context)!.premium_feature_title1_desc,
        icon: Icons.import_export,
        color: const Color(0xFF10B981),
      ),
      _FeatureItem(
        title: AppLocalizations.of(context)!.premium_feature_title2,
        subtitle: AppLocalizations.of(context)!.premium_feature_title2_desc,
        icon: Icons.widgets,
        color: const Color(0xFF3B82F6),
      ),
      _FeatureItem(
        title: AppLocalizations.of(context)!.premium_feature_title3,
        subtitle: AppLocalizations.of(context)!.premium_feature_title3_desc,
        icon: Icons.show_chart,
        color: const Color(0xFFF59E0B),
      ),
      _FeatureItem(
        title: AppLocalizations.of(context)!.premium_feature_title4,
        subtitle: AppLocalizations.of(context)!.premium_feature_title4_desc,
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
          Text(
            AppLocalizations.of(context)!.premium_feature_title,
            style: TextStyle(
              color: AppColors.darkColor,
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
                  style: TextStyle(
                    color: AppColors.darkColor.withOpacity(0.7),
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
