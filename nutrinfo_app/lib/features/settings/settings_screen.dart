import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutrinfo_app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final isDark = themeModeAsync.when(
      data: (mode) => mode == ThemeMode.dark,
      loading: () => true,
      error: (e, s) => true,
    );

    return Scaffold(
      backgroundColor: context.bgScreen,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                // ── PRO Card (Coming Soon) ──
                _buildProCard(context),
                SizedBox(height: 32),

                // ── ACCOUNT PREFERENCES ──
                _buildSectionTitle(context, 'Account Preferences'),
                SizedBox(height: 16),

                // Dark Mode toggle
                _buildToggleRow(
                  context,
                  icon: PhosphorIconsFill.moon,
                  iconColor: context.accentCyan,
                  label: 'Dark Mode',
                  value: isDark,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).toggle();
                  },
                ),
                SizedBox(height: 10),

                // Push Notifications toggle
                _buildToggleRow(
                  context,
                  icon: PhosphorIconsFill.bellSimple,
                  iconColor: context.accentMint,
                  label: 'Push Notifications',
                  value: true,
                  onChanged: (val) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: context.bgInput,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),

                // Dietary Profile toggle
                _buildToggleRow(
                  context,
                  icon: PhosphorIconsFill.forkKnife,
                  iconColor: context.accentGold,
                  label: 'Dietary Profile',
                  value: false,
                  onChanged: (val) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: context.bgInput,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                SizedBox(height: 32),

                // ── Personal Info card ──
                _buildLargeMenuCard(
                  context,
                  icon: PhosphorIconsFill.userCircle,
                  iconBgColor: context.accentMint.withAlpha(30),
                  iconColor: context.accentMint,
                  title: 'Personal Info',
                  subtitle: 'Height, Weight, Age',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: context.bgInput,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                SizedBox(height: 12),

                // ── Privacy card ──
                _buildLargeMenuCard(
                  context,
                  icon: PhosphorIconsFill.shieldCheck,
                  iconBgColor: context.accentCyan.withAlpha(30),
                  iconColor: context.accentCyan,
                  title: 'Privacy',
                  subtitle: 'Data usage & tracking',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: context.bgInput,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                SizedBox(height: 32),

                // ── Apply for Expert ──
                _buildMenuRow(
                  context,
                  icon: PhosphorIconsRegular.certificate,
                  label: 'Apply for Expert',
                  trailingText: 'NEW',
                  trailingColor: context.accentGold,
                  onTap: () => context.push('/expert'),
                ),
                SizedBox(height: 10),

                // ── Reviews ──
                _buildMenuRow(
                  context,
                  icon: PhosphorIconsRegular.chatCircleDots,
                  label: 'Reviews & Community',
                  onTap: () => context.push('/reviews'),
                ),
                SizedBox(height: 10),

                // ── Help & Support ──
                _buildMenuRow(
                  context,
                  icon: PhosphorIconsRegular.question,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                SizedBox(height: 10),

                // ── About ──
                _buildMenuRow(
                  context,
                  icon: PhosphorIconsRegular.info,
                  label: 'About Nutrinfo',
                  onTap: () {},
                ),

                SizedBox(height: 32),

                // DELETE ACCOUNT
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Coming soon!'),
                          backgroundColor: context.bgInput,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: Icon(
                      PhosphorIconsFill.trash,
                      color: Color(0xFFFF5252),
                      size: 18,
                    ),
                    label: Text(
                      'DELETE ACCOUNT',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF5252),
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Version
                Center(
                  child: Column(
                    children: [
                      Text(
                        'NUTRINFO VERSION 1.0.0',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.textSecondary.withAlpha(100),
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '© 2024 DIGITAL VITALIST INC.',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: context.textSecondary.withAlpha(80),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 120),
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
        color: context.bgHeader.withAlpha(204),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(102),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.bgInput.withAlpha(150),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 28,
                        height: 28,
                        errorBuilder: (c, e, s) => Icon(
                          PhosphorIconsFill.leaf,
                          color: context.accentMint,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 10),
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
                  Spacer(),
                  // PRO badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.accentMint.withAlpha(25),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: context.accentMint.withAlpha(51),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      'PRO',
                      style: TextStyle(
                        color: context.accentMint,
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

  Widget _buildProCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.accentMint, context.accentCyan],
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
                    colors: [Colors.white.withAlpha(30), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(28),
            child: Column(
              children: [
                // Premium member badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(60),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIconsFill.diamond,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 6),
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
                SizedBox(height: 20),
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
                SizedBox(height: 10),
                Text(
                  'Unlock the full potential of AI-driven\nhealth',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withAlpha(180),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 20),
                // Feature pills
                _buildProFeature(context, 'Unlimited Food Scans'),
                SizedBox(height: 8),
                _buildProFeature(context, '24/7 Nutritionist Chat'),
                SizedBox(height: 20),
                // Upgrade (Coming Soon)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
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
                        color: context.accentMint,
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

  Widget _buildProFeature(BuildContext context, String text) {
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
          child: Icon(PhosphorIconsBold.check, color: Colors.white, size: 14),
        ),
        SizedBox(width: 10),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Center(
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: context.textSecondary,
          letterSpacing: 3.0,
        ),
      ),
    );
  }

  // ── Toggle row ──

  Widget _buildToggleRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.bgCard,
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
          SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: context.accentMint,
            inactiveTrackColor: context.bgInput,
          ),
        ],
      ),
    );
  }

  // ── Large menu card (Personal Info / Privacy) ──

  Widget _buildLargeMenuCard(
    BuildContext context, {
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
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.bgCard,
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
            SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: context.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ── Menu row ──

  Widget _buildMenuRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? trailingText,
    Color? trailingColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: context.textSecondary, size: 22),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
            ),
            if (trailingText != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: (trailingColor ?? context.accentMint).withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trailingText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: trailingColor ?? context.accentMint,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            Icon(
              PhosphorIconsRegular.caretRight,
              color: Color(0xFF666666),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
