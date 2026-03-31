import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutrinfo_app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReviewsScreen extends ConsumerWidget {
  final String? productName;

  ReviewsScreen({super.key, this.productName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.bgScreen,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                // Rating summary
                _buildRatingSummary(context),
                SizedBox(height: 32),

                // Expert Highlight
                _buildExpertCard(context),
                SizedBox(height: 16),

                // Community reviews
                _buildCommunityCard(
                  context,
                  initials: 'MK',
                  role: 'Premium Member • 2h ago',
                  body:
                      'Tested ${productName ?? "this product"} before my morning fasted cardio. Mental clarity was noticeable within 20 mins. Great alternative to high-stim pre-workouts.',
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
                  initials: 'SK',
                  role: 'Premium Member • 8h ago',
                  body:
                      "Love that this is 100% transparent with the sourcing. It's rare to find such high-quality amino profiles in vegan options.",
                  votes: '156',
                ),
                SizedBox(height: 120),
              ],
            ),
          ),
          // Input bar at bottom
          _buildInputBar(context),
        ],
      ),
    );
  }

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
                  Expanded(
                    child: Text(
                      productName != null
                          ? 'Reviews: $productName'
                          : 'Reviews & Community',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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

  Widget _buildRatingSummary(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.bgInput.withAlpha(102),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: context.accentMint.withAlpha(30),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COMMUNITY INTELLIGENCE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8BD5FF),
                      letterSpacing: 3.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Insights & Reviews',
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.bgInput.withAlpha(153),
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
      ),
    );
  }

  Widget _buildExpertCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.accentGold.withAlpha(128),
            Color(0xFF00BDFD).withAlpha(128),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.accentGold.withAlpha(25),
              Color(0xFF00BDFD).withAlpha(13),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVoteColumn(context, '1.2k', isExpert: true),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.accentGold,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(77),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              PhosphorIconsFill.shieldCheck,
                              color: Color(0xFF251A00),
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
                                color: context.accentMint,
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
                  Text(
                    'The glycemic response for this profile is exceptionally stable. Pairing the high fiber content with the specific fat ratios ensures a sustained energy release without insulin spikes.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary.withAlpha(230),
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 16),
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

  Widget _buildCommunityCard(
    BuildContext context, {
    required String initials,
    required String role,
    required String body,
    required String votes,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.bgCard.withAlpha(102),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(13), width: 1.0),
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
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF00BDFD).withAlpha(51),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF00BDFD).withAlpha(77),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          initials,
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

  Widget _buildTag(BuildContext context, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(102),
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
                        color: context.textSecondary.withAlpha(128),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.accentMint,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.accentMint.withAlpha(51),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(
              PhosphorIconsBold.arrowUp,
              color: Color(0xFF007134),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
