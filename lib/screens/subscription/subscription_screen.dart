import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/subscription_provider.dart';
import '../../models/subscription.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.yearly;

  @override
  Widget build(BuildContext context) {
    final sub = Provider.of<SubscriptionProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Membership & Plans 💳', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Plan Status Card
            GlassCard(
              borderColor: sub.isPremium ? const Color(0xFFD0FD38) : Colors.white24,
              child: Row(
                children: [
                  Icon(
                    sub.isPremium ? Icons.verified : Icons.lock_outline,
                    color: sub.isPremium ? const Color(0xFFD0FD38) : Colors.white60,
                    size: 32,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.isPremium ? 'FITPULSE PRO ACTIVE' : 'FREE PLAN',
                          style: TextStyle(
                            color: sub.isPremium ? const Color(0xFFD0FD38) : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sub.isPremium
                              ? 'Enjoying unlimited AI Coach & Advanced Analytics'
                              : 'Upgrade to unlock all premium features',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Plan Options Toggle Cards
            Row(
              children: [
                Expanded(
                  child: _buildPlanCard(
                    plan: SubscriptionPlan.monthly,
                    title: 'Monthly',
                    price: '\$9.99',
                    subtext: '/ month',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPlanCard(
                    plan: SubscriptionPlan.yearly,
                    title: 'Yearly (Best Value)',
                    price: '\$79.99',
                    subtext: '/ year • 7-Day Free Trial',
                    badge: 'SAVE 33%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Feature Comparison Matrix
            const Text('Feature Matrix', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GlassCard(
              child: Column(
                children: [
                  _buildMatrixRow('Basic Workout Tracking', true, true),
                  _buildMatrixRow('Exercise Library (50+ exercises)', true, true),
                  _buildMatrixRow('Unlimited Custom Routines', false, true),
                  _buildMatrixRow('Advanced Analytics & Volume Curves', false, true),
                  _buildMatrixRow('AI Personal Trainer 24/7 Chat', false, true),
                  _buildMatrixRow('AI Custom Workout Generator', false, true),
                  _buildMatrixRow('Custom Meal Plans & Macro Targets', false, true),
                  _buildMatrixRow('Progress Photo Compare Tool', false, true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (sub.isPremium) ...[
              CustomButton(
                text: 'Cancel Subscription',
                isPrimary: false,
                onPressed: () async {
                  await sub.cancelSubscription();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscription cancelled.')));
                  }
                },
              ),
            ] else ...[
              CustomButton(
                text: _selectedPlan == SubscriptionPlan.yearly ? 'Start 7-Day Free Trial' : 'Upgrade to Premium Now',
                onPressed: () async {
                  if (_selectedPlan == SubscriptionPlan.yearly) {
                    await sub.startFreeTrial();
                  } else {
                    await sub.activatePlan(SubscriptionPlan.monthly);
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Welcome to FitPulse PRO! 🎉')));
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required SubscriptionPlan plan,
    required String title,
    required String price,
    required String subtext,
    String? badge,
  }) {
    final isSelected = _selectedPlan == plan;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = plan),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF232738) : const Color(0xFF1B1E2B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFFD0FD38) : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(color: const Color(0xFFD0FD38), borderRadius: BorderRadius.circular(6)),
                child: Text(badge, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 6),
            Text(price, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text(subtext, style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixRow(String feature, bool free, bool pro) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(feature, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Icon(free ? Icons.check : Icons.close, color: free ? Colors.white60 : Colors.white24, size: 16),
          const SizedBox(width: 24),
          Icon(pro ? Icons.check_circle : Icons.close, color: pro ? const Color(0xFFD0FD38) : Colors.white24, size: 18),
        ],
      ),
    );
  }
}
