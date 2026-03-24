import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/widgets/shimmer_network_image.dart';

class ExpertDashboardScreen extends ConsumerWidget {
  const ExpertDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Column(
        children: [
          // Header — expert avatar + role + bell
          _buildHeader(context),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 0, bottom: 120, left: 24, right: 24),
              children: [
                const SizedBox(height: 16),
                // Hero section
                _buildHeroSection(),
                const SizedBox(height: 40),

                // Analytics cards
                _buildAnalyticsCard(
                  label: 'TOTAL INSIGHTS READ',
                  icon: PhosphorIconsRegular.eye,
                  value: '14.2k',
                  subtitle: '+12% this week',
                ),
                const SizedBox(height: 16),
                _buildAnalyticsCard(
                  label: 'COMMUNITY UPVOTES',
                  icon: PhosphorIconsRegular.thumbsUp,
                  value: '890',
                  subtitle: 'Top 1% Contributor',
                ),
                const SizedBox(height: 40),

                // Foods Needing Analysis header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Foods Needing\nAnalysis',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE5E2E1),
                      ),
                    ),
                    const Text(
                      '24 PENDING\nTASKS',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB9CBB8),
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Food list rows
                _buildFoodRow(
                  imageUrl: 'https://images.unsplash.com/photo-1598511726623-d2e9996e91a4?w=150&q=80',
                  name: "Trader Joe's\nCauliflower\nGnocchi",
                  category: 'Category:\nFrozen / Plant-Based',
                ),
                const SizedBox(height: 16),
                _buildFoodRow(
                  imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=150&q=80',
                  name: 'A2 Organic\nPlain Greek\nYogurt',
                  category: 'Category:\nDairy / Probiotics',
                ),
                const SizedBox(height: 16),
                _buildFoodRow(
                  imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=150&q=80',
                  name: 'Ginger Lemon\nProbiotic\nKombucha',
                  category: 'Category:\nBeverages / Fermented',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Expert header — avatar with shield badge + role
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A).withAlpha(204), // zinc-950/80
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Avatar with shield badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF353534),
                                width: 2.0,
                              ),
                            ),
                            child: const ClipOval(
                              child: ShimmerNetworkImage(
                                imageUrl: 'https://ui-avatars.com/api/?name=DrSmith&background=random&size=100',
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDF95), // tertiary-fixed
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(77),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                PhosphorIconsFill.shield,
                                color: Color(0xFF251A00),
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'VERIFIED NUTRITIONIST',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB9CBB8),
                              letterSpacing: 3.0,
                            ),
                          ),
                          Text(
                            'Vitalist Pro',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Bell icon
                  Icon(
                    PhosphorIconsRegular.bell,
                    color: const Color(0xFF00FF7F),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Hero welcome section
  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome\nback, Dr.\nSmith.',
          style: GoogleFonts.manrope(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFE5E2E1),
            height: 1.05,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your expert insights are shaping 12\nnew health profiles today.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFB9CBB8),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  /// Analytics glass card with cyan glow
  Widget _buildAnalyticsCard({
    required String label,
    required IconData icon,
    required String value,
    required String subtitle,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A).withAlpha(102), // glass-panel
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00BDFD).withAlpha(25), // secondary-container/10
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00BDFD).withAlpha(38), // cyan-glow
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB9CBB8),
                      letterSpacing: 2.0,
                    ),
                  ),
                  Icon(icon, color: const Color(0xFF8BD5FF), size: 22),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.manrope(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00BDFD), // secondary-container
                      letterSpacing: -3,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF00BDFD).withAlpha(128), // cyan-glow-intense
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8BD5FF).withAlpha(153), // secondary/60
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Food row with image, name, category, and "Add Insight" button
  Widget _buildFoodRow({
    required String imageUrl,
    required String name,
    required String category,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B), // surface-container-low
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 40,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF353534),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ShimmerNetworkImage(imageUrl: imageUrl),
            ),
          ),
          const SizedBox(width: 16),
          // Name + category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE5E2E1),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFB9CBB8),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          // Add Insight button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF00BDFD), // secondary-container
              borderRadius: BorderRadius.circular(9999),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BDFD).withAlpha(77), // shadow
                  blurRadius: 20,
                ),
              ],
            ),
            child: Text(
              'Add\nInsight',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF004964), // on-secondary-container
              ),
            ),
          ),
        ],
      ),
    );
  }
}
