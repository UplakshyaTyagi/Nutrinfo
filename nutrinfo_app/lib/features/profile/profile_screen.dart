import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../theme/app_theme.dart';
import '../../core/widgets/shimmer_network_image.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _darkMode = true;
  bool _pushNotifications = true;
  bool _dietaryProfile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Column(
        children: [
          // Header — transparent bg, backdrop-blur-xl
          _buildHeader(),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 0, bottom: 120, left: 24, right: 24),
              children: [
                const SizedBox(height: 8),
                // Premium PRO card
                _buildProCard(),
                const SizedBox(height: 40),

                // Account Preferences glass panel
                _buildAccountPreferences(),
                const SizedBox(height: 24),

                // Profile Detail Cards (Personal Info + Privacy)
                _buildDetailCard(
                  icon: PhosphorIconsRegular.user,
                  iconColor: const Color(0xFF00FF7F), // primary-container
                  iconBg: const Color(0xFF00FF7F).withAlpha(25), // primary-container/10
                  title: 'Personal Info',
                  subtitle: 'Height, Weight, Age',
                ),
                const SizedBox(height: 24),
                _buildDetailCard(
                  icon: PhosphorIconsFill.shieldCheck,
                  iconColor: const Color(0xFF8BD5FF), // secondary
                  iconBg: const Color(0xFF8BD5FF).withAlpha(25), // secondary/10
                  title: 'Privacy',
                  subtitle: 'Data usage & tracking',
                ),
                const SizedBox(height: 40),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Header — avatar + "Nutrinfo" + PRO button
  Widget _buildHeader() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          color: Colors.transparent,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Avatar + Nutrinfo
                  Row(
                    children: [
                      // Avatar — 40x40, rounded-full
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2A2A2A),
                        ),
                        child: const ClipOval(
                          child: ShimmerNetworkImage(
                            imageUrl: 'https://ui-avatars.com/api/?name=Alex&background=random&size=100',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Nutrinfo',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF00FF7F),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  // Right: PRO button — solid mint bg
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FF7F),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'PRO',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00210B), // on-primary-fixed
                        letterSpacing: -0.3,
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

  /// Premium PRO card — radial-gradient(circle at top left, #00FF7F → #00d4ff)
  Widget _buildProCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [Color(0xFF00FF7F), Color(0xFF00D4FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF7F).withAlpha(38), // rgba(0,255,127,0.15)
            blurRadius: 50,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative blurred circle
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(51), // white/20
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                // "PREMIUM MEMBER" badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00210B).withAlpha(25), // on-primary-fixed/10
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: const Color(0xFF00210B).withAlpha(25), // on-primary-fixed/10
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIconsFill.star,
                        color: const Color(0xFF00210B),
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'PREMIUM MEMBER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00210B), // on-primary-fixed
                          letterSpacing: 3.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // "Elevate Your Nutrition"
                Text(
                  'Elevate Your\nNutrition',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF00210B), // on-primary-fixed
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock the full potential of AI-driven health',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF00210B).withAlpha(179), // on-primary-fixed/70
                  ),
                ),
                const SizedBox(height: 24),
                // Feature bullets
                _buildFeatureBullet('Unlimited Food Scans'),
                const SizedBox(height: 12),
                _buildFeatureBullet('24/7 Nutritionist Chat'),
                const SizedBox(height: 24),
                // "Upgrade Now" button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00210B), // on-primary-fixed
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(77),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    'Upgrade Now',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF00FF7F), // primary-container
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

  /// Feature bullet inside PRO card
  Widget _buildFeatureBullet(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF00210B).withAlpha(13), // on-primary-fixed/5
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PhosphorIconsFill.checkCircle,
            color: const Color(0xFF00210B),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00210B), // on-primary-fixed
            ),
          ),
        ],
      ),
    );
  }

  /// Account Preferences glass panel with toggles
  Widget _buildAccountPreferences() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A).withAlpha(102), // glass-panel
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              // Section title
              const Text(
                'ACCOUNT PREFERENCES',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB9CBB8),
                  letterSpacing: 3.5,
                ),
              ),
              const SizedBox(height: 24),
              // Toggle rows
              _buildToggleRow(
                icon: PhosphorIconsRegular.moon,
                iconColor: const Color(0xFF00FF7F), // primary-container
                label: 'Dark Mode',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              const SizedBox(height: 12),
              _buildToggleRow(
                icon: PhosphorIconsFill.bell,
                iconColor: const Color(0xFF8BD5FF), // secondary
                label: 'Push Notifications',
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
              ),
              const SizedBox(height: 12),
              _buildToggleRow(
                icon: PhosphorIconsRegular.forkKnife,
                iconColor: const Color(0xFFE6C26C), // tertiary-fixed-dim
                label: 'Dietary Profile',
                value: _dietaryProfile,
                onChanged: (v) => setState(() => _dietaryProfile = v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Single toggle row inside account preferences
  Widget _buildToggleRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B).withAlpha(102), // surface-container-low/40
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withAlpha(13), width: 1.0), // white/5
      ),
      child: Row(
        children: [
          // Icon box — 48x48, rounded-2xl
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A), // surface-container-high
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 20),
          // Label
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE5E2E1),
              ),
            ),
          ),
          // Custom toggle — 56x28 pill
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 56,
              height: 28,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: value
                    ? const Color(0xFF00FF7F) // primary-container
                    : const Color(0xFF353534), // surface-container-highest
                borderRadius: BorderRadius.circular(9999),
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00FF7F).withAlpha(77), // toggle glow
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value
                        ? const Color(0xFF00210B) // on-primary-fixed (dark dot)
                        : const Color(0xFFB9CBB8).withAlpha(102), // on-surface-variant/40
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(38),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile detail card (Personal Info / Privacy)
  Widget _buildDetailCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A).withAlpha(102), // glass-panel
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withAlpha(13), width: 1.0), // white/5
          ),
          child: Column(
            children: [
              // Icon circle
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE5E2E1),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFB9CBB8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Footer — Delete Account + version info
  Widget _buildFooter() {
    return Column(
      children: [
        // Delete Account button
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PhosphorIconsRegular.trashSimple,
                  color: const Color(0xFF93000A).withAlpha(204), // error-container/80
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'DELETE ACCOUNT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF93000A).withAlpha(204), // error-container/80
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Version info
        Opacity(
          opacity: 0.4,
          child: Column(
            children: [
              const Text(
                'NUTRINFO VERSION 4.2.0',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB9CBB8),
                  letterSpacing: 4.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2024 DIGITAL VITALIST INC.',
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFFB9CBB8),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
