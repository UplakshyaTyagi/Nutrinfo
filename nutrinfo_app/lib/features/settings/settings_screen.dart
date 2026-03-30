import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final isDark = themeModeAsync.when(
      data: (mode) => mode == ThemeMode.dark,
      loading: () => true,
      error: (e, s) => true,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                // ── PRO Card (Coming Soon) ──
                _buildProCard(),
                const SizedBox(height: 32),

                // ── ACCOUNT PREFERENCES ──
                _buildSectionTitle('Account Preferences'),
                const SizedBox(height: 16),

                // Dark Mode toggle
                _buildToggleRow(
                  icon: PhosphorIconsFill.moon,
                  iconColor: const Color(0xFF00BFFF),
                  label: 'Dark Mode',
                  value: isDark,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).toggle();
                  },
                ),
                const SizedBox(height: 10),

                // Push Notifications toggle
                _buildToggleRow(
                  icon: PhosphorIconsFill.bellSimple,
                  iconColor: const Color(0xFF00FF7F),
                  label: 'Push Notifications',
                  value: true,
                  onChanged: (val) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: Color(0xFF2A2A2A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Dietary Profile toggle
                _buildToggleRow(
                  icon: PhosphorIconsFill.forkKnife,
                  iconColor: const Color(0xFFFFDF95),
                  label: 'Dietary Profile',
                  value: false,
                  onChanged: (val) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: Color(0xFF2A2A2A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ── Personal Info card ──
                _buildLargeMenuCard(
                  icon: PhosphorIconsFill.userCircle,
                  iconBgColor: const Color(0xFF00FF7F).withAlpha(30),
                  iconColor: const Color(0xFF00FF7F),
                  title: 'Personal Info',
                  subtitle: 'Height, Weight, Age',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: Color(0xFF2A2A2A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // ── Privacy card ──
                _buildLargeMenuCard(
                  icon: PhosphorIconsFill.shieldCheck,
                  iconBgColor: const Color(0xFF00BFFF).withAlpha(30),
                  iconColor: const Color(0xFF00BFFF),
                  title: 'Privacy',
                  subtitle: 'Data usage & tracking',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: Color(0xFF2A2A2A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ── Apply for Expert ──
                _buildMenuRow(
                  icon: PhosphorIconsRegular.certificate,
                  label: 'Apply for Expert',
                  trailingText: 'NEW',
                  trailingColor: const Color(0xFFFFDF95),
                  onTap: () => context.push('/expert'),
                ),
                const SizedBox(height: 10),

                // ── Reviews ──
                _buildMenuRow(
                  icon: PhosphorIconsRegular.chatCircleDots,
                  label: 'Reviews & Community',
                  onTap: () => context.push('/reviews'),
                ),
                const SizedBox(height: 10),

                // ── Help & Support ──
                _buildMenuRow(
                  icon: PhosphorIconsRegular.question,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                const SizedBox(height: 10),

                // ── About ──
                _buildMenuRow(
                  icon: PhosphorIconsRegular.info,
                  label: 'About Nutrinfo',
                  onTap: () {},
                ),

                const SizedBox(height: 32),

                // DELETE ACCOUNT
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Coming soon!'),
                          backgroundColor: Color(0xFF2A2A2A),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(PhosphorIconsFill.trash,
                        color: Color(0xFFFF5252), size: 18),
                    label: Text(
                      'DELETE ACCOUNT',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFF5252),
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Version
                Center(
                  child: Column(
                    children: [
                      Text(
                        'NUTRINFO VERSION 1.0.0',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFB9CBB8).withAlpha(100),
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '© 2024 DIGITAL VITALIST INC.',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFB9CBB8).withAlpha(80),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──

  Widget _buildHeader(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A).withAlpha(150),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Image.asset('assets/images/logo.png',
                          width: 28, height: 28,
                          errorBuilder: (c, e, s) => const Icon(
                                PhosphorIconsFill.leaf,
                                color: Color(0xFF00FF7F),
                                size: 24,
                              )),
                      const SizedBox(width: 10),
                      Text(
                        'Nutrinfo',
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // PRO badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF7F).withAlpha(25),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: const Color(0xFF00FF7F).withAlpha(51),
                        width: 1.0,
                      ),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Color(0xFF00FF7F),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
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

  // ── PRO Card (Coming Soon) ──

  Widget _buildProCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00FF7F), Color(0xFF00BFFF)],
        ),
      ),
      child: Stack(
        children: [
          // Overlay pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withAlpha(30),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                // Premium member badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(60),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(PhosphorIconsFill.diamond,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'PREMIUM MEMBER',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Elevate Your\nNutrition',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Unlock the full potential of AI-driven\nhealth',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withAlpha(180),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                // Feature pills
                _buildProFeature('Unlimited Food Scans'),
                const SizedBox(height: 8),
                _buildProFeature('24/7 Nutritionist Chat'),
                const SizedBox(height: 20),
                // Upgrade (Coming Soon)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Coming Soon',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF00FF7F),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProFeature(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(100),
            shape: BoxShape.circle,
          ),
          child: const Icon(PhosphorIconsBold.check,
              color: Colors.white, size: 14),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // ── Section title ──

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFB9CBB8),
          letterSpacing: 3.0,
        ),
      ),
    );
  }

  // ── Toggle row ──

  Widget _buildToggleRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
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

  // ── Large menu card (Personal Info / Privacy) ──

  Widget _buildLargeMenuCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B1B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFE5E2E1),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFB9CBB8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Menu row ──

  Widget _buildMenuRow({
    required IconData icon,
    required String label,
    String? trailingText,
    Color? trailingColor,
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
            if (trailingText != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: (trailingColor ?? const Color(0xFF00FF7F))
                      .withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trailingText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: trailingColor ?? const Color(0xFF00FF7F),
                    letterSpacing: 1.0,
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
