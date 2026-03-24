import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/widgets/shimmer_network_image.dart';

/// Show the reviews bottom sheet as a modal
void showReviewsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(153), // black/60
    builder: (context) => const ReviewsSheet(),
  );
}

class ReviewsSheet extends ConsumerWidget {
  const ReviewsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
        child: Container(
          height: screenHeight * 0.85,
          decoration: BoxDecoration(
            color: const Color(0xFF131313).withAlpha(217), // rgba(19,19,19,0.85)
            borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
            border: const Border(
              top: BorderSide(color: Color(0x1AFFFFFF), width: 1.0), // white/10
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(127),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51), // white/20
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),

              // Header — "COMMUNITY INTELLIGENCE" + "Insights & Reviews" + rating
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COMMUNITY INTELLIGENCE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8BD5FF), // secondary
                            letterSpacing: 3.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Insights & Reviews',
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE5E2E1),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    // Rating badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A).withAlpha(153), // surface-container-high/60
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: Colors.white.withAlpha(13), width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            PhosphorIconsFill.star,
                            color: Color(0xFF00FF7F),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '4.8',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE5E2E1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable reviews list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Expert Highlight Card — gradient border (gold→cyan)
                    _buildExpertCard(),
                    const SizedBox(height: 16),
                    // Regular community cards
                    _buildCommunityCard(
                      avatarUrl: 'https://ui-avatars.com/api/?name=Marcus&background=random&size=100',
                      role: 'Premium Member • 2h ago',
                      body: 'Tested this before my morning fasted cardio. Mental clarity was noticeable within 20 mins. Great alternative to high-stim pre-workouts.',
                      votes: '842',
                    ),
                    const SizedBox(height: 16),
                    _buildCommunityCard(
                      initials: 'EL',
                      role: 'Community Member • 5h ago',
                      body: "Decent flavor, but the texture is a bit gritty. Nutritionally it's perfect for my recovery window. 4/5 stars.",
                      votes: '329',
                    ),
                    const SizedBox(height: 16),
                    _buildCommunityCard(
                      avatarUrl: 'https://ui-avatars.com/api/?name=Sarah&background=random&size=100',
                      role: 'Premium Member • 8h ago',
                      body: "Love that this is 100% transparent with the sourcing. It's rare to find such high-quality amino profiles in vegan options.",
                      votes: '156',
                    ),
                    const SizedBox(height: 120), // Space for input bar
                  ],
                ),
              ),

              // Floating input bar
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// Expert highlight card with gradient border
  Widget _buildExpertCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFDF95).withAlpha(128), // tertiary-fixed/50
            const Color(0xFF00BDFD).withAlpha(128), // secondary-container/50
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5), // border width
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFDF95).withAlpha(25), // tertiary-fixed/10
              const Color(0xFF00BDFD).withAlpha(13), // secondary-container/5
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Voting column
            _buildVoteColumn('1.2k', isExpert: true),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expert avatar + name + role
                  Row(
                    children: [
                      // Shield avatar with verified badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFFDF95), // tertiary-fixed
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(77),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              PhosphorIconsFill.shieldCheck,
                              color: Color(0xFF251A00), // on-tertiary-fixed
                              size: 24,
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFF131313),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                PhosphorIconsFill.sealCheck,
                                color: Color(0xFF00FF7F), // primary-container
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verified Expert',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE5E2E1),
                            ),
                          ),
                          const Text(
                            'Clinical Nutritionist • 12m ago',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFB9CBB8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Body text
                  Text(
                    'The glycemic response for this profile is exceptionally stable. Pairing the high fiber content with the specific fat ratios ensures a sustained energy release without insulin spikes. Highly recommended for metabolic health.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE5E2E1).withAlpha(230), // on-surface/90
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tags
                  Row(
                    children: [
                      _buildTag('METABOLIC'),
                      const SizedBox(width: 8),
                      _buildTag('SCIENTIFIC'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Regular community review card
  Widget _buildCommunityCard({
    String? avatarUrl,
    String? initials,
    required String role,
    required String body,
    required String votes,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B).withAlpha(102), // surface-container-low/40
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(13), width: 1.0), // white/5
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVoteColumn(votes),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + role
                Row(
                  children: [
                    if (avatarUrl != null)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withAlpha(25), width: 1.0),
                        ),
                        child: ClipOval(
                          child: ShimmerNetworkImage(imageUrl: avatarUrl),
                        ),
                      )
                    else
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BDFD).withAlpha(51), // secondary-container/20
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00BDFD).withAlpha(77), // secondary-container/30
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF00BDFD),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFB9CBB8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB9CBB8),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Upvote/downvote column
  Widget _buildVoteColumn(String count, {bool isExpert = false}) {
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Icon(
            PhosphorIconsBold.caretUp,
            color: const Color(0xFFB9CBB8),
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isExpert ? FontWeight.w900 : FontWeight.bold,
              color: const Color(0xFFE5E2E1),
            ),
          ),
          const SizedBox(height: 2),
          Icon(
            PhosphorIconsBold.caretDown,
            color: const Color(0xFFB9CBB8),
            size: 22,
          ),
        ],
      ),
    );
  }

  /// Tag pill
  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(102), // black/40
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(13), width: 1.0),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB9CBB8),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  /// Floating input bar at the bottom
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF131313).withAlpha(0),
            const Color(0xFF131313).withAlpha(230),
            const Color(0xFF131313),
          ],
        ),
      ),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withAlpha(25), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(127),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.chatCircleDots,
                    color: const Color(0xFFB9CBB8),
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Write a review...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFB9CBB8).withAlpha(128), // on-surface-variant/50
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Send button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF00FF7F), // primary-container
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF7F).withAlpha(51), // primary-container/20
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              PhosphorIconsBold.arrowUp,
              color: Color(0xFF007134), // on-primary-container
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
