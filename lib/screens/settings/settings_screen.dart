import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_button.dart';
import '../subscription/subscription_screen.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _workoutNotif = true;
  bool _waterNotif = true;
  bool _mealNotif = true;
  bool _streakNotif = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final sub = Provider.of<SubscriptionProvider>(context);
    final user = auth.userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Account & Settings ⚙️', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            GlassCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFD0FD38),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0] : 'A',
                      style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(user.email, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFFD0FD38)),
                    onPressed: () => _showEditProfileDialog(context, auth),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Membership Management Card
            GlassCard(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SubscriptionScreen())),
              borderColor: const Color(0xFFD0FD38),
              child: Row(
                children: [
                  const Icon(Icons.card_membership, color: Color(0xFFD0FD38), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sub.isPremium ? 'FitPulse PRO Active' : 'Upgrade to Premium', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(sub.isPremium ? 'Manage plan & billing' : 'Unlock AI, analytics & meal plans', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Push Notification Settings
            const Text('Push Notification Alerts', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GlassCard(
              child: Column(
                children: [
                  _buildSwitchRow('💪 Workout Reminders', '30 minutes before routine', _workoutNotif, (v) => setState(() => _workoutNotif = v)),
                  _buildSwitchRow('💧 Water Reminders', 'Stay hydrated throughout the day', _waterNotif, (v) => setState(() => _waterNotif = v)),
                  _buildSwitchRow('🍎 Meal Log Alerts', 'Don\'t forget your high protein meals', _mealNotif, (v) => setState(() => _mealNotif = v)),
                  _buildSwitchRow('🔥 Streak Notifications', 'Daily streak status & motivation', _streakNotif, (v) => setState(() => _streakNotif = v)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Security & Biometrics
            const Text('Security & Biometrics', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GlassCard(
              child: Column(
                children: [
                  _buildSwitchRow('Fingerprint / Face ID Login', 'Enable biometric fast authentication', user.isBiometricEnabled, (v) {
                    auth.toggleBiometrics(v);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account Actions
            CustomButton(
              text: 'Log Out',
              isPrimary: false,
              onPressed: () async {
                await auth.logout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => _showDeleteAccountDialog(context, auth),
                child: const Text('Delete Account', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFFD0FD38),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthProvider auth) {
    final nameCtrl = TextEditingController(text: auth.userProfile.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Full Name', labelStyle: TextStyle(color: Colors.white60)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD0FD38), foregroundColor: Colors.black),
            onPressed: () {
              auth.userProfile.name = nameCtrl.text;
              auth.updateProfile(auth.userProfile);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        title: const Text('Delete Account?', style: TextStyle(color: Colors.redAccent)),
        content: const Text('This will permanently erase all your workout logs, PRs, and custom routines.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await auth.deleteAccount();
              if (ctx.mounted) {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const LoginScreen()), (r) => false);
              }
            },
            child: const Text('Permanently Delete'),
          ),
        ],
      ),
    );
  }
}
