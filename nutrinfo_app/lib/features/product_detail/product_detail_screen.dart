import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../providers/product_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(productId) ?? 0;
    final productAsync = ref.watch(productByIdProvider(id));

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: productAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF00FF7F)),
              SizedBox(height: 16),
              Text('Loading product...', style: TextStyle(color: Color(0xFFB9CBB8))),
            ],
          ),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(PhosphorIconsRegular.warning, color: Color(0xFFFF5252), size: 48),
              const SizedBox(height: 16),
              Text('Error: $err', style: const TextStyle(color: Color(0xFFB9CBB8))),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF7F)),
                child: const Text('Go Back', style: TextStyle(color: Color(0xFF003917))),
              ),
            ],
          ),
        ),
        data: (product) {
          if (product == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(PhosphorIconsRegular.magnifyingGlass, color: Color(0xFFB9CBB8), size: 48),
                  const SizedBox(height: 16),
                  Text('Product nutrition info has not been updated yet.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(fontSize: 16, color: const Color(0xFFE5E2E1)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF7F)),
                    child: const Text('Go Back', style: TextStyle(color: Color(0xFF003917))),
                  ),
                ],
              ),
            );
          }
          return _buildProductView(context, product);
        },
      ),
    );
  }

  Widget _buildProductView(BuildContext context, Map<String, dynamic> product) {
    final name = product['product_name'] as String? ?? 'Unknown Product';
    final score = (product['health_score'] as num?)?.toDouble() ?? 5.0;
    final category = product['health_category'] as String? ?? 'Eatable';
    final sugars = (product['sugars_100g'] as num?)?.toDouble() ?? 0;
    final satFat = (product['sat_fat_100g'] as num?)?.toDouble() ?? 0;
    final sodium = (product['sodium_mg_100g'] as num?)?.toDouble() ?? 0;
    final fiber = (product['fiber_100g'] as num?)?.toDouble() ?? 0;
    final protein = (product['protein_100g'] as num?)?.toDouble() ?? 0;
    final calories = (product['calories_100g'] as num?)?.toDouble() ?? 0;
    final nova = (product['nova_group'] as num?)?.toInt() ?? 0;
    final additives = (product['additives_n'] as num?)?.toInt() ?? 0;

    final gaugeColors = score >= 7.0
        ? [const Color(0xFF00FF7F), const Color(0xFF00BFFF)]
        : score >= 4.5
            ? [const Color(0xFF00BFFF), const Color(0xFFFFDF95)]
            : [const Color(0xFFFF5252), const Color(0xFFFFAB91)];

    return Stack(
      children: [
        // Ambient glow
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.5),
                  radius: 1.2,
                  colors: [
                    gaugeColors[0].withAlpha(15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8, bottom: 120, left: 24, right: 24),
                children: [
                  const SizedBox(height: 16),
                  // Product name
                  Text(
                    name,
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFE5E2E1),
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Category badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: gaugeColors[0].withAlpha(25),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: gaugeColors[0].withAlpha(50)),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: gaugeColors[0],
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  // Score gauge
                  _buildScoreGauge(score, gaugeColors),

                  const SizedBox(height: 40),
                  // Nutrition breakdown
                  _buildSectionTitle('Nutrition per 100g'),
                  const SizedBox(height: 16),
                  _buildNutrientGrid(
                    sugars: sugars,
                    satFat: satFat,
                    sodium: sodium,
                    fiber: fiber,
                    protein: protein,
                    calories: calories,
                  ),

                  const SizedBox(height: 32),
                  // Additional info
                  _buildSectionTitle('Processing & Additives'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildInfoCard('NOVA Group', '$nova', _novaColor(nova))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard('Additives', '$additives', _additivesColor(additives))),
                    ],
                  ),

                  const SizedBox(height: 32),
                  // AI Tips
                  _buildSectionTitle('AI Insights'),
                  const SizedBox(height: 16),
                  _buildInsightsCard(sugars, satFat, sodium, fiber, protein, score),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A).withAlpha(204),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A).withAlpha(150),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Product Analysis',
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

  Widget _buildScoreGauge(double score, List<Color> colors) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: CustomPaint(
          painter: _ScoreGaugePainter(score: score, colors: colors),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  score.toStringAsFixed(1),
                  style: GoogleFonts.manrope(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: colors[0],
                    height: 1,
                  ),
                ),
                Text(
                  '/ 10',
                  style: TextStyle(fontSize: 14, color: colors[0].withAlpha(150)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFB9CBB8),
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildNutrientGrid({
    required double sugars,
    required double satFat,
    required double sodium,
    required double fiber,
    required double protein,
    required double calories,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildNutrientCard('Calories', '${calories.toStringAsFixed(0)} kcal', const Color(0xFFFFDF95))),
            const SizedBox(width: 12),
            Expanded(child: _buildNutrientCard('Protein', '${protein.toStringAsFixed(1)}g', const Color(0xFF00BFFF))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildNutrientCard('Sugars', '${sugars.toStringAsFixed(1)}g', const Color(0xFFFF5252))),
            const SizedBox(width: 12),
            Expanded(child: _buildNutrientCard('Fiber', '${fiber.toStringAsFixed(1)}g', const Color(0xFF00FF7F))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildNutrientCard('Sat. Fat', '${satFat.toStringAsFixed(1)}g', const Color(0xFFFFAB91))),
            const SizedBox(width: 12),
            Expanded(child: _buildNutrientCard('Sodium', '${sodium.toStringAsFixed(0)}mg', const Color(0xFFCE93D8))),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color.withAlpha(180))),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: const Color(0xFFB9CBB8))),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }

  Color _novaColor(int nova) {
    if (nova <= 1) return const Color(0xFF00FF7F);
    if (nova == 2) return const Color(0xFF00BFFF);
    if (nova == 3) return const Color(0xFFFFDF95);
    return const Color(0xFFFF5252);
  }

  Color _additivesColor(int count) {
    if (count == 0) return const Color(0xFF00FF7F);
    if (count <= 3) return const Color(0xFFFFDF95);
    return const Color(0xFFFF5252);
  }

  Widget _buildInsightsCard(double sugars, double satFat, double sodium, double fiber, double protein, double score) {
    final tips = <String>[];
    if (sugars > 20) tips.add('⚠️ High sugar content — limit daily intake');
    if (satFat > 10) tips.add('⚠️ High saturated fat — choose leaner alternatives');
    if (sodium > 600) tips.add('⚠️ High sodium — watch your salt intake');
    if (fiber > 5) tips.add('✅ Good fiber content — supports digestion');
    if (protein > 15) tips.add('✅ High protein — great for muscle health');
    if (score >= 8) tips.add('🌟 Excellent overall health score!');
    if (tips.isEmpty) tips.add('ℹ️ Moderate nutritional profile');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00FF7F).withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tips
            .map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(tip,
                      style: GoogleFonts.manrope(
                          fontSize: 14, color: const Color(0xFFE5E2E1), height: 1.4)),
                ))
            .toList(),
      ),
    );
  }
}

class _ScoreGaugePainter extends CustomPainter {
  final double score;
  final List<Color> colors;

  _ScoreGaugePainter({required this.score, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const startAngle = 2.3;
    const totalSweep = 4.6;
    final sweepAngle = (score / 10.0) * totalSweep;

    // Background arc
    final bgPaint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, totalSweep, false, bgPaint,
    );

    // Score arc with gradient
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: colors,
    );

    final scorePaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle, false, scorePaint,
    );

    // Glow dot at the end
    final dotAngle = startAngle + sweepAngle;
    final dotX = center.dx + radius * cos(dotAngle);
    final dotY = center.dy + radius * sin(dotAngle);
    final glowPaint = Paint()
      ..color = colors[0].withAlpha(80)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(dotX, dotY), 8, glowPaint);

    final dotPaint = Paint()..color = colors[0];
    canvas.drawCircle(Offset(dotX, dotY), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
