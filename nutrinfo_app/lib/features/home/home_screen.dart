import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../providers/product_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 120, left: 24, right: 24),
              children: [
                const SizedBox(height: 24),
                _buildHeroWelcome(context),
                const SizedBox(height: 40),
                _buildScanCTA(context),
                const SizedBox(height: 40),
                _buildQuickActionsRow(context),
                const SizedBox(height: 40),
                _buildTrendingSwapsSection(),
              ],
            ),
          ),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nutrinfo. branding
                  Row(
                    children: [
                      Image.asset('assets/images/logo.png',
                          width: 32, height: 32,
                          errorBuilder: (_, __, ___) => const Icon(
                                PhosphorIconsFill.leaf,
                                color: Color(0xFF00FF7F),
                                size: 28,
                              )),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                          children: const [
                            TextSpan(text: 'Nutrinfo'),
                            TextSpan(
                              text: '.',
                              style: TextStyle(color: Color(0xFF00FF7F)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Search + Settings icons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: _ProductSearchDelegate(),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A).withAlpha(150),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withAlpha(20), width: 1),
                          ),
                          child: const Icon(
                            PhosphorIconsRegular.magnifyingGlass,
                            color: Color(0xFFB9CBB8),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => context.push('/settings'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A).withAlpha(150),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withAlpha(20), width: 1),
                          ),
                          child: const Icon(
                            PhosphorIconsRegular.gearSix,
                            color: Color(0xFFB9CBB8),
                            size: 20,
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

  Widget _buildHeroWelcome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_greeting()}.',
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
          'Scan something to discover\nwhat\'s really inside.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFB9CBB8),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildScanCTA(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/scanner'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
          child: Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A).withAlpha(102),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF00FF7F).withAlpha(25),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FF7F).withAlpha(13),
                  blurRadius: 40,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF7F).withAlpha(25),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FF7F).withAlpha(38),
                        blurRadius: 30,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Icon(
                    PhosphorIconsFill.scan,
                    color: const Color(0xFF00FF7F),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Scan a Product',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE5E2E1),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to open camera and analyze\nany food product instantly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB9CBB8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickAction(
            icon: PhosphorIconsRegular.clockCounterClockwise,
            label: 'History',
            color: const Color(0xFF00BFFF),
            onTap: () => context.go('/history'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickAction(
            icon: PhosphorIconsRegular.magnifyingGlass,
            label: 'Search',
            color: const Color(0xFF00FF7F),
            onTap: () {
              showSearch(
                context: context,
                delegate: _ProductSearchDelegate(),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickAction(
            icon: PhosphorIconsRegular.chatCircleDots,
            label: 'Reviews',
            color: const Color(0xFFFFDF95),
            onTap: () => context.push('/reviews'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A).withAlpha(102),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withAlpha(25), width: 1.0),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSwapsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending\nHealthy Swaps',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE5E2E1),
              ),
            ),
            const Text(
              'CURATED\nFOR YOU',
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
        _buildSwapCard(
            name: 'Greek Yogurt', category: 'Dairy · High Protein', score: 8.8),
        const SizedBox(height: 12),
        _buildSwapCard(
            name: 'Overnight Oats', category: 'Grains · Fiber Rich', score: 8.2),
        const SizedBox(height: 12),
        _buildSwapCard(
            name: 'Mixed Berries Bowl',
            category: 'Fruits · Antioxidants',
            score: 9.1),
      ],
    );
  }

  Widget _buildSwapCard({
    required String name,
    required String category,
    required double score,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF353534),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(PhosphorIconsRegular.forkKnife,
                color: Color(0xFFB9CBB8), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE5E2E1))),
                const SizedBox(height: 2),
                Text(category,
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFFB9CBB8))),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF00FF7F).withAlpha(51),
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFF00FF7F).withAlpha(77), width: 1.0),
            ),
            child: Center(
              child: Text(
                score.toStringAsFixed(1),
                style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF00FF7F)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search Delegate ─────────────────────────────────────────────────────────

class _ProductSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search products...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF131313), elevation: 0),
      scaffoldBackgroundColor: const Color(0xFF131313),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Color(0xFFB9CBB8)),
        border: InputBorder.none,
      ),
      textTheme:
          const TextTheme(titleLarge: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Color(0xFFB9CBB8)),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF00FF7F)),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) =>
      _SearchResults(query: query);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return Container(
        color: const Color(0xFF131313),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(PhosphorIconsRegular.magnifyingGlass,
                  color: const Color(0xFFB9CBB8).withAlpha(100), size: 48),
              const SizedBox(height: 16),
              Text('Search for any food product',
                  style: TextStyle(
                      color: const Color(0xFFB9CBB8).withAlpha(150),
                      fontSize: 16)),
              const SizedBox(height: 4),
              Text('e.g. "Chocolate", "Green Tea", "Yogurt"',
                  style: TextStyle(
                      color: const Color(0xFFB9CBB8).withAlpha(100),
                      fontSize: 13)),
            ],
          ),
        ),
      );
    }
    return _SearchResults(query: query);
  }
}

class _SearchResults extends ConsumerWidget {
  final String query;
  const _SearchResults({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(productSearchProvider(query));

    return Container(
      color: const Color(0xFF131313),
      child: resultsAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF00FF7F))),
        error: (err, _) => Center(
            child: Text('Error: $err',
                style: const TextStyle(color: Color(0xFFB9CBB8)))),
        data: (products) {
          if (products.isEmpty) {
            return Center(
                child: Text('No products found for "$query"',
                    style: const TextStyle(color: Color(0xFFB9CBB8))));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                _buildResultCard(context, products[index]),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, Map<String, dynamic> product) {
    final score = (product['health_score'] as num?)?.toDouble() ?? 5.0;
    final name = product['product_name'] as String? ?? 'Unknown';
    final category = product['health_category'] as String? ?? '';
    final id = product['id'] as int? ?? 0;

    final scoreColor = score >= 7.0
        ? const Color(0xFF00FF7F)
        : score >= 4.5
            ? const Color(0xFF00BFFF)
            : const Color(0xFFFF5252);

    return GestureDetector(
      onTap: () => context.push('/product-detail/$id'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B1B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF353534),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(PhosphorIconsRegular.forkKnife,
                  color: Color(0xFFB9CBB8), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE5E2E1)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (category.isNotEmpty)
                    Text(category,
                        style: TextStyle(
                            fontSize: 13,
                            color: scoreColor.withAlpha(180))),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scoreColor.withAlpha(51),
                shape: BoxShape.circle,
                border:
                    Border.all(color: scoreColor.withAlpha(77), width: 1.0),
              ),
              child: Center(
                child: Text(score.toStringAsFixed(1),
                    style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: scoreColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
