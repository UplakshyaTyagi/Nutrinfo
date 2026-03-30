import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                // Rating summary
                _buildRatingSummary(),
                const SizedBox(height: 32),

                // Expert Highlight
                _buildExpertCard(),
                const SizedBox(height: 16),

                // Community reviews
                _buildCommunityCard(
                  initials: 'MK',
                  role: 'Premium Member • 2h ago',
                  body:
                      'Tested this before my morning fasted cardio. Mental clarity was noticeable within 20 mins. Great alternative to high-stim pre-workouts.',
                  votes: '842',
                ),
                const SizedBox(height: 16),
                _buildCommunityCard(
                  initials: 'EL',
                  role: 'Community Member • 5h ago',
                  body:
                      "Decent flavor, but the texture is a bit gritty. Nutritionally it's perfect for my recovery window. 4/5 stars.",
                  votes: '329',
                ),
                const SizedBox(height: 16),
                _buildCommunityCard(
                  initials: 'SK',
                  role: 'Premium Member • 8h ago',
                  body:
                      "Love that this is 100% transparent with the sourcing. It's rare to find such high-quality amino profiles in vegan options.",
                  votes: '156',
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
          // Input bar at bottom
          _buildInputBar(),
        ],
      ),
    );
  }

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
                  Text(
                    'Reviews & Community',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  Widget _buildRatingSummary() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A).withAlpha(102),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF00FF7F).withAlpha(30),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COMMUNITY INTELLIGENCE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8BD5FF),
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Insights & Reviews',
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE5E2E1),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A).withAlpha(153),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                      color: Colors.white.withAlpha(13), width: 1.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(PhosphorIconsFill.star,
                        color: Color(0xFF00FF7F), size: 18),
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
      ),
    );
  }

  Widget _buildExpertCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFDF95).withAlpha(128),
            const Color(0xFF00BDFD).withAlpha(128),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFDF95).withAlpha(25),
              const Color(0xFF00BDFD).withAlpha(13),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVoteColumn('1.2k', isExpert: true),
            const SizedBox(width: 16),
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
                              color: const Color(0xFFFFDF95),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(77),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              PhosphorIconsFill.shieldCheck,
                              color: Color(0xFF251A00),
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
                                color: Color(0xFF00FF7F),
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
                  Text(
                    'The glycemic response for this profile is exceptionally stable. Pairing the high fiber content with the specific fat ratios ensures a sustained energy release without insulin spikes.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE5E2E1).withAlpha(230),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
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

  Widget _buildCommunityCard({
    required String initials,
    required String role,
    required String body,
    required String votes,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B).withAlpha(102),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(13), width: 1.0),
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
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BDFD).withAlpha(51),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00BDFD).withAlpha(77),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          initials,
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

  Widget _buildVoteColumn(String count, {bool isExpert = false}) {
    return SizedBox(
      width: 40,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Icon(PhosphorIconsBold.caretUp,
              color: const Color(0xFFB9CBB8), size: 22),
          const SizedBox(height: 2),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  isExpert ? FontWeight.w900 : FontWeight.bold,
              color: const Color(0xFFE5E2E1),
            ),
          ),
          const SizedBox(height: 2),
          Icon(PhosphorIconsBold.caretDown,
              color: const Color(0xFFB9CBB8), size: 22),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(102),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: Colors.white.withAlpha(13), width: 1.0),
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.white.withAlpha(25), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(127),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(PhosphorIconsRegular.chatCircleDots,
                      color: const Color(0xFFB9CBB8), size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Write a review...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFB9CBB8).withAlpha(128),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF00FF7F),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF7F).withAlpha(51),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(PhosphorIconsBold.arrowUp,
                color: Color(0xFF007134), size: 20),
          ),
        ],
      ),
    );
  }
}
