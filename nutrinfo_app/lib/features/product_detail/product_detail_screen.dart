import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/widgets/shimmer_network_image.dart';
import '../reviews/reviews_sheet.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  // Demo data matching the reference
  static const _productName = 'Doritos Nacho Cheese';
  static const _vitalityScore = 4.2;
  static const _matchIntegrity = 98;
  static const _protein = 2.0;
  static const _carbs = 18.0;
  static const _fats = 8.0;
  static const _reviewCount = '1.2k';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          // Ambient Background Blobs
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  // Top center mint blob
                  Positioned(
                    top: -120,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00FF7F).withAlpha(13), // primary/5
                              blurRadius: 120,
                              spreadRadius: 60,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom right cyan blob
                  Positioned(
                    bottom: -60,
                    right: -60,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00BFFF).withAlpha(13), // secondary/5
                            blurRadius: 100,
                            spreadRadius: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              // Header — fixed top nav
              _buildHeader(context),

              // Scrollable body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 120, left: 24, right: 24),
                  children: [
                    // Gauge Section
                    _buildGaugeSection(),
                    const SizedBox(height: 40),

                    // AI Analysis Card
                    _buildAIAnalysisCard(),
                    const SizedBox(height: 10),

                    // Nutrient Cards
                    _buildNutrientPill(
                      label: 'PROTEIN',
                      value: '${_protein}g',
                      percentage: 0.15,
                      color: const Color(0xFF00BFFF), // secondary
                      icon: PhosphorIconsFill.barbell,
                    ),
                    const SizedBox(height: 10),
                    _buildNutrientPill(
                      label: 'CARBS',
                      value: '${_carbs}g',
                      percentage: 0.65,
                      color: const Color(0xFF00FF7F), // primary
                      icon: PhosphorIconsFill.grains,
                    ),
                    const SizedBox(height: 10),
                    _buildNutrientPill(
                      label: 'FATS',
                      value: '${_fats}g',
                      percentage: 0.40,
                      color: const Color(0xFFFF5252), // error
                      icon: PhosphorIconsFill.drop,
                    ),
                    const SizedBox(height: 10),

                    // Community Reviews Button
                    _buildCommunityReviewsButton(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Fixed top header matching the reference
  Widget _buildHeader(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A).withAlpha(204), // surface/80
            border: const Border(
              bottom: BorderSide(color: Color(0x0DFFFFFF), width: 1.0), // white/5
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Back arrow + Nutrinfo.
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back, color: Color(0xFFF2F2F2), size: 24),
                      ),
                      const SizedBox(width: 16),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                          children: const [
                            TextSpan(text: 'Nutrinfo'),
                            TextSpan(text: '.', style: TextStyle(color: Color(0xFF00FF7F))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Right: PRO + Avatar
                  Row(
                    children: [
                      // PRO badge — bg-primary/10, text-primary, border-primary/20
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00FF7F).withAlpha(25), // primary/10
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: const Color(0xFF00FF7F).withAlpha(51), // primary/20
                            width: 1.0,
                          ),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            color: Color(0xFF00FF7F),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Avatar — border white/10
                      Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withAlpha(25), width: 1.0),
                        ),
                        child: const ClipOval(
                          child: ShimmerNetworkImage(
                            imageUrl: 'https://ui-avatars.com/api/?name=Alex&background=random&size=100',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Vitality Score gauge with product name and match integrity badge
  Widget _buildGaugeSection() {
    return Column(
      children: [
        // Gauge
        SizedBox(
          width: 256,
          height: 192,
          child: CustomPaint(
            painter: _VitalityGaugePainter(
              score: _vitalityScore,
              maxScore: 10.0,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _vitalityScore.toStringAsFixed(1),
                      style: GoogleFonts.manrope(
                        fontSize: 72,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -3,
                        height: 1.0,
                        shadows: [
                          Shadow(
                            color: Colors.white.withAlpha(25),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'V I T A L I T Y   S C O R E',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA0A0A0),
                        letterSpacing: 4.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Product Name
        Text(
          _productName,
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Match Integrity Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF00FF7F).withAlpha(13), // primary/5
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: const Color(0xFF00FF7F).withAlpha(25), // primary/10
              width: 1.0,
            ),
          ),
          child: Text(
            '$_matchIntegrity% MATCH INTEGRITY',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FF7F),
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// AI Analysis glass card with insight bullets
  Widget _buildAIAnalysisCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withAlpha(102), // rgba(30,30,30,0.4)
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(20), width: 1.0), // white/8%
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(94), // rgba(0,0,0,0.37)
                blurRadius: 32,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: icon + "AI Analysis" + sparkle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Psychology icon in green circle
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00FF7F).withAlpha(25), // primary/10
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00FF7F).withAlpha(51), // primary/20
                            width: 1.0,
                          ),
                        ),
                        child: const Icon(
                          PhosphorIconsFill.brain,
                          color: Color(0xFF00FF7F),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'AI Analysis',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    PhosphorIconsRegular.sparkle,
                    color: const Color(0xFF00FF7F).withAlpha(102), // primary/40
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bullet insights
              _buildInsightBullet(
                color: const Color(0xFFFF5252), // error
                text: 'High sodium density (210mg/oz) detected. May lead to fluid retention.',
              ),
              const SizedBox(height: 20),
              _buildInsightBullet(
                color: const Color(0xFF00BFFF), // secondary
                text: 'MSG content may trigger metabolic spikes in sensitive profiles.',
              ),
              const SizedBox(height: 20),
              _buildInsightBullet(
                color: const Color(0xFF00FF7F), // primary
                text: 'Balance with ',
                richText: true,
                highlightText: '24oz of electrolytes',
                trailingText: ' to offset dehydration.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Single insight bullet with optional highlighted text
  Widget _buildInsightBullet({
    required Color color,
    required String text,
    bool richText = false,
    String? highlightText,
    String? trailingText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Glowing dot
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(153), // 60%
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: richText
              ? RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFA0A0A0),
                      height: 1.6,
                    ),
                    children: [
                      TextSpan(text: text),
                      TextSpan(
                        text: highlightText,
                        style: const TextStyle(
                          color: Color(0xFF00FF7F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: trailingText),
                    ],
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA0A0A0),
                    height: 1.6,
                  ),
                ),
        ),
      ],
    );
  }

  /// Nutrient pill card with icon, label, value, and progress bar
  Widget _buildNutrientPill({
    required String label,
    required String value,
    required double percentage,
    required Color color,
    required IconData icon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withAlpha(102), // glass-card bg
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: Colors.white.withAlpha(20), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(94),
                blurRadius: 32,
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withAlpha(25), // color/10
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withAlpha(51), width: 1.0), // color/20
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 16),
              // Label + value + progress bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFA0A0A0).withAlpha(153), // on-surface-variant/60
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        SizedBox(
                          width: 48,
                          child: Text(
                            value,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Progress bar
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(13), // white/5
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: percentage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(9999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withAlpha(77), // 30%
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Chevron
              Icon(
                Icons.chevron_right,
                color: const Color(0xFFA0A0A0).withAlpha(77), // on-surface-variant/30
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Community Reviews CTA button
  Widget _buildCommunityReviewsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showReviewsSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(13), // white/5
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: Colors.white.withAlpha(25), width: 1.0), // white/10
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              PhosphorIconsRegular.chatTeardrop,
              color: Color(0xFF00FF7F),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Community Reviews ($_reviewCount)',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the semi-circular vitality score gauge
class _VitalityGaugePainter extends CustomPainter {
  final double score;
  final double maxScore;

  _VitalityGaugePainter({required this.score, required this.maxScore});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.75);
    final radius = size.width * 0.42;

    // The gauge is a semi-circle spanning from ~210° to ~330° (top arc)
    const startAngle = 210 * (pi / 180); // Start from bottom-left
    const sweepTotal = 120 * 2 * (pi / 180); // 240 degrees total sweep
    final scoreSweep = (score / maxScore) * sweepTotal;

    // Track (background arc)
    final trackPaint = Paint()
      ..color = Colors.white.withAlpha(13) // white/5
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      trackPaint,
    );

    // Tick marks
    final tickPaint = Paint()
      ..color = Colors.white.withAlpha(13)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 20; i++) {
      final angle = startAngle + (sweepTotal * i / 20);
      final innerR = radius - 10;
      final outerR = radius - 6;
      canvas.drawLine(
        Offset(center.dx + innerR * cos(angle), center.dy + innerR * sin(angle)),
        Offset(center.dx + outerR * cos(angle), center.dy + outerR * sin(angle)),
        tickPaint,
      );
    }

    // Active progress arc with gradient
    final progressRect = Rect.fromCircle(center: center, radius: radius);
    final progressPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepTotal,
        colors: [Color(0xFFFF5252), Color(0xFFFFAB91)], // error → salmon
      ).createShader(progressRect)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      progressRect,
      startAngle,
      scoreSweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
