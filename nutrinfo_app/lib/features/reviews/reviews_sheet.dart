import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutrinfo_app/theme/app_colors.dart';
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
    builder: (context) => ReviewsSheet(),
  );
}

class ReviewsSheet extends ConsumerWidget {
  ReviewsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
        child: Container(
          height: screenHeight * 0.85,
          decoration: BoxDecoration(
            color: context.bgScreen.withAlpha(217), // rgba(19,19,19,0.85)
            borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
            border: Border(
              top: BorderSide(color: Color(0x1AFFFFFF), width: 1.0), // white/10
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(127), blurRadius: 24),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.borderWhite20, // white/20
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),

              // Header — "COMMUNITY INTELLIGENCE" + "Insights & Reviews" + rating
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COMMUNITY INTELLIGENCE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8BD5FF), // secondary
                            letterSpacing: 3.0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Insights & Reviews',
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    // Rating badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: context.bgInput.withAlpha(
                          153,
                        ), // surface-container-high/60
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                          color: Colors.white.withAlpha(13),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            PhosphorIconsFill.star,
                            color: context.accentMint,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '4.8',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
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
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Expert Highlight Card — gradient border (gold→cyan)
                    _buildExpertCard(context),
                    SizedBox(height: 16),
                    // Regular community cards
                    _buildCommunityCard(
                      context,
                      avatarUrl:
                          'https://ui-avatars.com/api/?name=Marcus&background=random&size=100',
                      role: 'Premium Member • 2h ago',
                      body:
                          'Tested this before my morning fasted cardio. Mental clarity was noticeable within 20 mins. Great alternative to high-stim pre-workouts.',
                      votes: '842',
                    ),
                    SizedBox(height: 16),
                    _buildCommunityCard(
                      context,
                      initials: 'EL',
                      role: 'Community Member • 5h ago',
                      body:
                          "Decent flavor, but the texture is a bit gritty. Nutritionally it's perfect for my recovery window. 4/5 stars.",
                      votes: '329',
                    ),
                    SizedBox(height: 16),
                    _buildCommunityCard(
                      context,
                      avatarUrl:
                          'https://ui-avatars.com/api/?name=Sarah&background=random&size=100',
                      role: 'Premium Member • 8h ago',
                      body:
                          "Love that this is 100% transparent with the sourcing. It's rare to find such high-quality amino profiles in vegan options.",
                      votes: '156',
                    ),
                    SizedBox(height: 120), // Space for input bar
                  ],
                ),
              ),

              // Floating input bar
              _buildInputBar(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Expert highlight card with gradient border
  Widget _buildExpertCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.accentGold.withAlpha(128), // tertiary-fixed/50
            Color(0xFF00BDFD).withAlpha(128), // secondary-container/50
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(1.5), // border width
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.accentGold.withAlpha(25), // tertiary-fixed/10
              Color(0xFF00BDFD).withAlpha(13), // secondary-container/5
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Voting column
            _buildVoteColumn(context, '1.2k', isExpert: true),
            SizedBox(width: 16),
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
                              color: context.accentGold, // tertiary-fixed
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(77),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              PhosphorIconsFill.shieldCheck,
                              color: Color(0xFF251A00), // on-tertiary-fixed
                              size: 24,
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: context.bgScreen,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                PhosphorIconsFill.sealCheck,
                                color: context.accentMint, // primary-container
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verified Expert',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          Text(
                            'Clinical Nutritionist • 12m ago',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Body text
                  Text(
                    'The glycemic response for this profile is exceptionally stable. Pairing the high fiber content with the specific fat ratios ensures a sustained energy release without insulin spikes. Highly recommended for metabolic health.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary.withAlpha(
                        230,
                      ), // on-surface/90
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Tags
                  Row(
                    children: [
                      _buildTag(context, 'METABOLIC'),
                      SizedBox(width: 8),
                      _buildTag(context, 'SCIENTIFIC'),
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
  Widget _buildCommunityCard(
    BuildContext context, {
    String? avatarUrl,
    String? initials,
    required String role,
    required String body,
    required String votes,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.bgCard.withAlpha(102), // surface-container-low/40
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(13),
          width: 1.0,
        ), // white/5
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVoteColumn(context, votes),
          SizedBox(width: 16),
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
                          border: Border.all(
                            color: context.borderWhite10,
                            width: 1.0,
                          ),
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
                          color: Color(
                            0xFF00BDFD,
                          ).withAlpha(51), // secondary-container/20
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(
                              0xFF00BDFD,
                            ).withAlpha(77), // secondary-container/30
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF00BDFD),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 12),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textSecondary,
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
  Widget _buildVoteColumn(
    BuildContext context,
    String count, {
    bool isExpert = false,
  }) {
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          SizedBox(height: 4),
          Icon(
            PhosphorIconsBold.caretUp,
            color: context.textSecondary,
            size: 22,
          ),
          SizedBox(height: 2),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isExpert ? FontWeight.w900 : FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          SizedBox(height: 2),
          Icon(
            PhosphorIconsBold.caretDown,
            color: context.textSecondary,
            size: 22,
          ),
        ],
      ),
    );
  }

  /// Tag pill
  Widget _buildTag(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(102), // black/40
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(13), width: 1.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: context.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  /// Floating input bar at the bottom
  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.bgScreen.withAlpha(0),
            context.bgScreen.withAlpha(230),
            context.bgScreen,
          ],
        ),
      ),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: context.bgInput,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderWhite10, width: 1.0),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(127), blurRadius: 20),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.chatCircleDots,
                    color: context.textSecondary,
                    size: 18,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Write a review...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary.withAlpha(
                          128,
                        ), // on-surface-variant/50
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          // Send button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.accentMint, // primary-container
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.accentMint.withAlpha(
                    51,
                  ), // primary-container/20
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(
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
