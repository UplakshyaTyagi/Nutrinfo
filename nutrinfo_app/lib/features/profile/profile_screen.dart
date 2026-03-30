import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final isDark = themeModeAsync.when(
      data: (mode) => mode == ThemeMode.dark,
      loading: () => true,
      error: (_, __) => true,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                // App info card
                _buildAppInfoCard(),
                const SizedBox(height: 32),

                // Settings section
                _buildSectionTitle('Settings'),
                const SizedBox(height: 16),

                // Theme toggle
                _buildToggleRow(
                  icon: isDark
                      ? PhosphorIconsFill.moon
                      : PhosphorIconsFill.sunDim,
                  label: 'Dark Mode',
                  value: isDark,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).toggle();
                  },
                ),
                const SizedBox(height: 12),

                // Notification toggle
                _buildToggleRow(
                  icon: PhosphorIconsFill.bellSimple,
                  label: 'Notifications',
                  value: true,
                  onChanged: (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: Color(0xFF2A2A2A),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // About section
                _buildSectionTitle('About'),
                const SizedBox(height: 16),

                _buildMenuRow(
                  icon: PhosphorIconsRegular.info,
                  label: 'About Nutrinfo',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _buildMenuRow(
                  icon: PhosphorIconsRegular.shieldCheck,
                  label: 'Privacy Policy',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _buildMenuRow(
                  icon: PhosphorIconsRegular.question,
                  label: 'Help & Support',
                  onTap: () {},
                ),

                const SizedBox(height: 40),

                // Version info
                Center(
                  child: Text(
                    'Nutrinfo v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFB9CBB8).withAlpha(100),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A).withAlpha(204),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(102),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      children: const [
                        TextSpan(text: 'Settings'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A).withAlpha(102),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF00FF7F).withAlpha(30),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF7F).withAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (_, __, ___) => Icon(
                    PhosphorIconsFill.leaf,
                    color: const Color(0xFF00FF7F),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        children: const [
                          TextSpan(text: 'Nutrinfo'),
                          TextSpan(
                              text: '.',
                              style: TextStyle(color: Color(0xFF00FF7F))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Product Discovery & Intelligence',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB9CBB8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFB9CBB8),
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00FF7F), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE5E2E1),
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF00FF7F),
            inactiveTrackColor: const Color(0xFF353534),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B1B),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFB9CBB8), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE5E2E1),
                ),
              ),
            ),
            const Icon(PhosphorIconsRegular.caretRight,
                color: Color(0xFF666666), size: 18),
          ],
        ),
      ),
    );
  }
}
