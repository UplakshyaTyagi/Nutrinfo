import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../theme/app_theme.dart';
import '../../core/widgets/shimmer_network_image.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Column(
        children: [
          // Fixed Header — bg-[#131313]/80, backdrop-blur-2xl, border-b border-[#b9cbb8]/15
          _buildHeader(context),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 0, bottom: 120, left: 24, right: 24),
              children: [
                const SizedBox(height: 24),
                // Search bar with filter button
                _buildSearchBar(),
                const SizedBox(height: 40),

                // TODAY section
                _buildSectionHeader('TODAY'),
                const SizedBox(height: 24),
                _buildScanItem(
                  name: 'Doritos Nacho Cheese',
                  time: '2:15 PM',
                  score: 3.2,
                  imageUrl: 'https://images.unsplash.com/photo-1600952841320-db92ec4047ca?w=150&q=80',
                  isFaded: false,
                ),
                const SizedBox(height: 16),
                _buildScanItem(
                  name: 'Greek Yogurt',
                  time: '12:40 PM',
                  score: 8.8,
                  imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=150&q=80',
                  isFaded: false,
                ),
                const SizedBox(height: 16),
                _buildScanItem(
                  name: 'Almond Milk',
                  time: '9:05 AM',
                  score: 7.4,
                  imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=150&q=80',
                  isFaded: false,
                ),
                const SizedBox(height: 32),

                // YESTERDAY section (dimmed)
                _buildSectionHeader('YESTERDAY'),
                const SizedBox(height: 24),
                Opacity(
                  opacity: 0.6,
                  child: _buildScanItem(
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
            color: const Color(0xFF131313).withAlpha(204), // 80%
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFB9CBB8).withAlpha(38), // b9cbb8/15%
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF00FF7F),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Scan History',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE5E2E1),
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
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A).withAlpha(153), // surface-container-high/60
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(
            Icons.search,
            color: const Color(0xFFB9CBB8).withAlpha(204),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search your history...',
                hintStyle: TextStyle(
                  color: const Color(0xFFB9CBB8).withAlpha(153),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(
                color: Color(0xFFE5E2E1),
                fontSize: 14,
              ),
            ),
          ),
          // Filter button — bg-primary-container, text-on-primary
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF00FF7F),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Icon(
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
  Widget _buildSectionHeader(String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB9CBB8),
            letterSpacing: 3.0, // tracking-[0.2em]
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFF3B4B3C).withAlpha(51), // outline-variant/20
          ),
        ),
      ],
    );
  }

  /// Individual scan history item — glass card with product image, name, time, and score badge
  Widget _buildScanItem({
    required String name,
    required String time,
    required double score,
    required String imageUrl,
    required bool isFaded,
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
      scoreColor = const Color(0xFFFFB4AB); // error
      scoreBg = const Color(0xFF93000A).withAlpha(51); // error-container/20
      scoreBorder = const Color(0xFFFFB4AB).withAlpha(77); // error/30
      scoreShadow = [
        BoxShadow(
          color: const Color(0xFFFFB4AB).withAlpha(77), // neon-glow-red
          blurRadius: 15,
        ),
      ];
    } else if (isMid) {
      scoreColor = const Color(0xFF00BDFD); // secondary-container
      scoreBg = const Color(0xFF00BDFD).withAlpha(51); // secondary-container/20
      scoreBorder = const Color(0xFF00BDFD).withAlpha(77); // secondary-container/30
      scoreShadow = null; // No glow for mid range / yesterday items
    } else {
      scoreColor = const Color(0xFF00FF7F); // primary-container
      scoreBg = const Color(0xFF00FF7F).withAlpha(51); // primary-container/20
      scoreBorder = const Color(0xFF00FF7F).withAlpha(77); // primary-container/30
      scoreShadow = [
        BoxShadow(
          color: const Color(0xFF00FF7F).withAlpha(77), // neon-glow-mint
          blurRadius: 15,
        ),
      ];
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A).withAlpha(102), // glass-card: rgba(42,42,42,0.4)
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Product image — 64x64, rounded-2xl
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF353534), // surface-container-highest
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl.isNotEmpty
                      ? (isFaded
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                              child: ShimmerNetworkImage(imageUrl: imageUrl),
                            )
                          : ShimmerNetworkImage(imageUrl: imageUrl))
                      : Container(
                          color: const Color(0xFF2A2A2A),
                          child: const Center(
                            child: Icon(
                              PhosphorIconsRegular.forkKnife,
                              color: Color(0xFFB9CBB8),
                              size: 24,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
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
                        color: const Color(0xFFE5E2E1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.schedule, color: Color(0xFFB9CBB8), size: 12),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFB9CBB8),
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
    );
  }
}
