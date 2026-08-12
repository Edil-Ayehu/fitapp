import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../models/subscription.dart';
import 'custom_button.dart';

class PaywallModal extends StatefulWidget {
  final String title;
  final String subtitle;

  const PaywallModal({
    super.key,
    this.title = 'Unlock FitPulse Premium',
    this.subtitle = 'Accelerate your progress with AI Coaching, Advanced Analytics & Custom Meal Plans.',
  });

  static void show(BuildContext context, {String? title, String? subtitle}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaywallModal(
        title: title ?? 'Unlock FitPulse Premium',
        subtitle: subtitle ?? 'Accelerate your progress with AI Coaching, Advanced Analytics & Custom Meal Plans.',
      ),
    );
  }

  @override
  State<PaywallModal> createState() => _PaywallModalState();
}

class _PaywallModalState extends State<PaywallModal> {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.yearly;

  @override
  Widget build(BuildContext context) {
    final subProvider = Provider.of<SubscriptionProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xFF141722),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Color(0xFFD0FD38), width: 2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.local_fire_department, color: Color(0xFFD0FD38), size: 32),
              SizedBox(width: 8),
              Text(
                'FITPULSE PRO',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
          ),
          const SizedBox(height: 24),

          // Features checklist
          _buildFeatureRow('🤖 Unlimited AI Coach Chat & Recommendations'),
          _buildFeatureRow('📈 Advanced Strength & Volume Analytics Charts'),
          _buildFeatureRow('⚡ AI Custom Workout Generator Wizard'),
          _buildFeatureRow('🥗 Personalized Daily & Weekly Meal Plans'),
          _buildFeatureRow('📸 Side-by-side Progress Photo Comparison'),
          _buildFeatureRow('⌚ Apple Health & Health Connect Sync'),

          const SizedBox(height: 24),

          // Plan options
          Row(
            children: [
              Expanded(
                child: _buildPlanOptionCard(
                  plan: SubscriptionPlan.monthly,
                  title: 'Monthly',
                  price: '\$9.99',
                  period: '/ month',
                  badge: null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPlanOptionCard(
                  plan: SubscriptionPlan.yearly,
                  title: 'Yearly',
                  price: '\$79.99',
                  period: '/ year',
                  badge: 'SAVE 33%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          CustomButton(
            text: _selectedPlan == SubscriptionPlan.yearly ? 'Start 7-Day Free Trial' : 'Unlock Premium Now',
            icon: Icons.flash_on,
            onPressed: () async {
              if (_selectedPlan == SubscriptionPlan.yearly) {
                await subProvider.startFreeTrial();
              } else {
                await subProvider.activatePlan(SubscriptionPlan.monthly);
              }
              if (mounted) Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () async {
              await subProvider.restorePurchases();
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              'Restore Purchases',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFD0FD38), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptionCard({
    required SubscriptionPlan plan,
    required String title,
    required String price,
    required String period,
    String? badge,
  }) {
    final isSelected = _selectedPlan == plan;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = plan),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF232738) : const Color(0xFF1B1E2B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFD0FD38) : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD0FD38),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(period, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
