import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutrinfo_app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/widgets/shimmer_network_image.dart';

class HistoryScreen extends ConsumerWidget {
  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.bgScreen,
      body: Column(
        children: [
          // Fixed Header — bg-[#131313]/80, backdrop-blur-2xl, border-b border-[#b9cbb8]/15
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
                SizedBox(height: 24),
                // Search bar with filter button
                _buildSearchBar(context),
                SizedBox(height: 40),

                // TODAY section
                _buildSectionHeader(context, 'TODAY'),
                SizedBox(height: 24),
                _buildScanItem(
                  context,
                  name: 'Doritos Nacho Cheese',
                  time: '2:15 PM',
                  score: 3.2,
                  imageUrl:
                      'https://images.unsplash.com/photo-1600952841320-db92ec4047ca?w=150&q=80',
                  isFaded: false,
                ),
                SizedBox(height: 16),
                _buildScanItem(
                  context,
                  name: 'Greek Yogurt',
                  time: '12:40 PM',
                  score: 8.8,
                  imageUrl:
                      'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=150&q=80',
                  isFaded: false,
                ),
                SizedBox(height: 16),
                _buildScanItem(
                  context,
                  name: 'Almond Milk',
                  time: '9:05 AM',
                  score: 7.4,
                  imageUrl:
                      'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=150&q=80',
                  isFaded: false,
                ),
                SizedBox(height: 32),

                // YESTERDAY section (dimmed)
                _buildSectionHeader(context, 'YESTERDAY'),
                SizedBox(height: 24),
                Opacity(
                  opacity: 0.6,
                  child: _buildScanItem(
                    context,
                    name: 'Whole Grain Bread',
                    time: 'Nov 22, 5:30 PM',
                    score: 6.5,
                    imageUrl: '', // No image → uses icon placeholder
                    isFaded: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fixed top header — Back arrow + "Scan History"
  Widget _buildHeader(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          decoration: BoxDecoration(
            color: context.bgScreen.withAlpha(204), // 80%
            border: Border(
              bottom: BorderSide(
                color: context.textSecondary.withAlpha(38), // b9cbb8/15%
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(102), // shadow-2xl
                blurRadius: 24,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: context.accentMint,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Scan History',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                      letterSpacing: -0.3,
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

  /// Search bar with filter button — pill shape, glass bg
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.bgInput.withAlpha(153), // surface-container-high/60
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          SizedBox(width: 20),
          Icon(
            Icons.search,
            color: context.textSecondary.withAlpha(204),
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search your history...',
                hintStyle: TextStyle(
                  color: context.textSecondary.withAlpha(153),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: TextStyle(color: context.textPrimary, fontSize: 14),
            ),
          ),
          // Filter button — bg-primary-container, text-on-primary
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 4),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.accentMint,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Icon(
                PhosphorIconsBold.slidersHorizontal,
                color: Color(0xFF003917), // on-primary
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section header with label + horizontal divider line
  Widget _buildSectionHeader(BuildContext context, String label) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: context.textSecondary,
            letterSpacing: 3.0, // tracking-[0.2em]
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            color: Color(0xFF3B4B3C).withAlpha(51), // outline-variant/20
          ),
        ),
      ],
    );
  }

  /// Individual scan history item — glass card with product image, name, time, and score badge
  Widget _buildScanItem(
    BuildContext context, {
    required String name,
    required String time,
    required double score,
    required String imageUrl,
    required bool isFaded,
    VoidCallback? onTap,
  }) {
    // Score coloring rules:
    // < 5.0 → error (red glow)
    // >= 5.0 and < 7.0 → secondary (cyan, no glow for yesterday items)
    // >= 7.0 → primary-container (mint glow)
    final bool isUnhealthy = score < 5.0;
    final bool isMid = score >= 5.0 && score < 7.0;

    final Color scoreColor;
    final Color scoreBg;
    final Color scoreBorder;
    List<BoxShadow>? scoreShadow;

    if (isUnhealthy) {
      scoreColor = Color(0xFFFFB4AB); // error
      scoreBg = Color(0xFF93000A).withAlpha(51); // error-container/20
      scoreBorder = Color(0xFFFFB4AB).withAlpha(77); // error/30
      scoreShadow = [
        BoxShadow(
          color: Color(0xFFFFB4AB).withAlpha(77), // neon-glow-red
          blurRadius: 15,
        ),
      ];
    } else if (isMid) {
      scoreColor = Color(0xFF00BDFD); // secondary-container
      scoreBg = Color(0xFF00BDFD).withAlpha(51); // secondary-container/20
      scoreBorder = Color(0xFF00BDFD).withAlpha(77); // secondary-container/30
      scoreShadow = null; // No glow for mid range / yesterday items
    } else {
      scoreColor = context.accentMint; // primary-container
      scoreBg = context.accentMint.withAlpha(51); // primary-container/20
      scoreBorder = context.accentMint.withAlpha(77); // primary-container/30
      scoreShadow = [
        BoxShadow(
          color: context.accentMint.withAlpha(77), // neon-glow-mint
          blurRadius: 15,
        ),
      ];
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.bgInput.withAlpha(102),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Product image — 64x64, rounded-2xl
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: context.bgInput, // surface-container-highest
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageUrl.isNotEmpty
                        ? (isFaded
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  ),
                                  child: ShimmerNetworkImage(
                                    imageUrl: imageUrl,
                                  ),
                                )
                              : ShimmerNetworkImage(imageUrl: imageUrl))
                        : Container(
                            color: context.bgInput,
                            child: Center(
                              child: Icon(
                                PhosphorIconsRegular.forkKnife,
                                color: context.textSecondary,
                                size: 24,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 16),
                // Name + time
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
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: context.textSecondary,
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 13,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Score badge — 48x48 circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: scoreBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: scoreBorder, width: 1.0),
                    boxShadow: scoreShadow,
                  ),
                  child: Center(
                    child: Text(
                      score.toStringAsFixed(1),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: scoreColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
