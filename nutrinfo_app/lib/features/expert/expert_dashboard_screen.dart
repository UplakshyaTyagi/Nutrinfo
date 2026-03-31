import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutrinfo_app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/widgets/shimmer_network_image.dart';

class ExpertDashboardScreen extends ConsumerWidget {
  ExpertDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.bgScreen,
      body: Column(
        children: [
          // Header — expert avatar + role + bell
          _buildHeader(context),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                top: 0,
                bottom: 120,
                left: 24,
                right: 24,
              ),
              children: [
                SizedBox(height: 16),
                // Hero section
                _buildHeroSection(context),
                SizedBox(height: 40),

                // Analytics cards
                _buildAnalyticsCard(
                  context,
                  label: 'TOTAL INSIGHTS READ',
                  icon: PhosphorIconsRegular.eye,
                  value: '14.2k',
                  subtitle: '+12% this week',
                ),
                SizedBox(height: 16),
                _buildAnalyticsCard(
                  context,
                  label: 'COMMUNITY UPVOTES',
                  icon: PhosphorIconsRegular.thumbsUp,
                  value: '890',
                  subtitle: 'Top 1% Contributor',
                ),
                SizedBox(height: 40),

                // Foods Needing Analysis header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Foods Needing\nAnalysis',
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    Text(
                      '24 PENDING\nTASKS',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.textSecondary,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Food list rows
                _buildFoodRow(
                  context,
                  imageUrl:
                      'https://images.unsplash.com/photo-1598511726623-d2e9996e91a4?w=150&q=80',
                  name: "Trader Joe's\nCauliflower\nGnocchi",
                  category: 'Category:\nFrozen / Plant-Based',
                ),
                SizedBox(height: 16),
                _buildFoodRow(
                  context,
                  imageUrl:
                      'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=150&q=80',
                  name: 'A2 Organic\nPlain Greek\nYogurt',
                  category: 'Category:\nDairy / Probiotics',
                ),
                SizedBox(height: 16),
                _buildFoodRow(
                  context,
                  imageUrl:
                      'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=150&q=80',
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
        color: context.bgHeader.withAlpha(204), // zinc-950/80
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
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                                color: context.bgInput,
                                width: 2.0,
                              ),
                            ),
                            child: ClipOval(
                              child: ShimmerNetworkImage(
                                imageUrl:
                                    'https://ui-avatars.com/api/?name=DrSmith&background=random&size=100',
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: context.accentGold, // tertiary-fixed
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(77),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                PhosphorIconsFill.shield,
                                color: Color(0xFF251A00),
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VERIFIED NUTRITIONIST',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: context.textSecondary,
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
                    color: context.accentMint,
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
  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome\nback, Dr.\nSmith.',
          style: GoogleFonts.manrope(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: context.textPrimary,
            height: 1.05,
            letterSpacing: -1.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Your expert insights are shaping 12\nnew health profiles today.',
          style: TextStyle(
            fontSize: 16,
            color: context.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  /// Analytics glass card with cyan glow
  Widget _buildAnalyticsCard(
    BuildContext context, {
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
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: context.bgInput.withAlpha(102), // glass-panel
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFF00BDFD).withAlpha(25), // secondary-container/10
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00BDFD).withAlpha(38), // cyan-glow
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
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.textSecondary,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Icon(icon, color: Color(0xFF8BD5FF), size: 22),
                ],
              ),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.manrope(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00BDFD), // secondary-container
                      letterSpacing: -3,
                      shadows: [
                        Shadow(
                          color: Color(
                            0xFF00BDFD,
                          ).withAlpha(128), // cyan-glow-intense
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8BD5FF).withAlpha(153), // secondary/60
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
  Widget _buildFoodRow(
    BuildContext context, {
    required String imageUrl,
    required String name,
    required String category,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.bgCard, // surface-container-low
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 40,
            offset: Offset(0, 4),
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
              color: context.bgInput,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ShimmerNetworkImage(imageUrl: imageUrl),
            ),
          ),
          SizedBox(width: 16),
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
                    color: context.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          // Add Insight button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF00BDFD), // secondary-container
              borderRadius: BorderRadius.circular(9999),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF00BDFD).withAlpha(77), // shadow
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
                color: Color(0xFF004964), // on-secondary-container
              ),
            ),
          ),
        ],
      ),
    );
  }
}
