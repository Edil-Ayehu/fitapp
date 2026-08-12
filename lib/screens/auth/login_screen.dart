import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_card.dart';
import '../onboarding/onboarding_quiz_screen.dart';
import '../dashboard/home_dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'alex.fitness@fitpulse.app');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: const [
                    Icon(Icons.bolt, color: Color(0xFFD0FD38), size: 48),
                    SizedBox(height: 8),
                    Text(
                      'Welcome Back',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Log in to continue your fitness journey',
                      style: TextStyle(fontSize: 14, color: Colors.white60),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              if (auth.authError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: Text(
                    auth.authError!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Email Input
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFD0FD38)),
                  filled: true,
                  fillColor: const Color(0xFF1B1E2B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),

              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFD0FD38)),
                  filled: true,
                  fillColor: const Color(0xFF1B1E2B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPasswordDialog(context, auth),
                  child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 13)),
                ),
              ),
              const SizedBox(height: 12),

              CustomButton(
                text: 'Log In',
                isLoading: auth.isLoading,
                onPressed: () async {
                  await auth.login(_emailController.text, _passwordController.text);
                  if (auth.isLoggedIn && mounted) {
                    if (!auth.userProfile.isOnboardingCompleted) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const OnboardingQuizScreen()));
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const HomeDashboardScreen()));
                    }
                  }
                },
              ),
              const SizedBox(height: 20),

              // Biometric Login Button
              GlassCard(
                onTap: () async {
                  await auth.socialLogin('Biometrics');
                  if (mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const HomeDashboardScreen()));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.fingerprint, color: Color(0xFFD0FD38), size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Log in with Face ID / Touch ID',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR SOCIAL LOGIN', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ),
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                ],
              ),
              const SizedBox(height: 16),

              // Social Logins
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Google',
                      isPrimary: false,
                      icon: Icons.g_mobiledata,
                      onPressed: () async {
                        await auth.socialLogin('Google');
                        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const HomeDashboardScreen()));
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Apple',
                      isPrimary: false,
                      icon: Icons.apple,
                      onPressed: () async {
                        await auth.socialLogin('Apple');
                        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const HomeDashboardScreen()));
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.white60)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const RegisterScreen())),
                    child: const Text('Sign Up', style: TextStyle(color: Color(0xFFD0FD38), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context, AuthProvider auth) {
    final emailCtrl = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F2332),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Password', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your registered email address to receive a password reset link.', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'user@example.com',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF141722),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD0FD38), foregroundColor: Colors.black),
            onPressed: () async {
              await auth.resetPassword(emailCtrl.text);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset instructions sent to your email!')),
                );
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }
}
