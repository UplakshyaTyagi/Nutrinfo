import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../providers/product_provider.dart';
import '../../core/utils/dynamic_icon_mapper.dart';
import '../../theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.bgScreen,
      body: Column(
        children: [
          _buildHeader(context),
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
                _buildHeroWelcome(context),
                SizedBox(height: 40),
                _buildScanCTA(context),
                SizedBox(height: 40),
                _buildQuickActionsRow(context),
                SizedBox(height: 40),
                _buildTrendingSwapsSection(context, ref),
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
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nutrinfo. branding
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 32,
                        height: 32,
                        errorBuilder: (_, __, ___) => Icon(
                          PhosphorIconsFill.leaf,
                          color: context.accentMint,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                          children: [
                            TextSpan(text: 'Nutrinfo'),
                            TextSpan(
                              text: '.',
                              style: TextStyle(color: context.accentMint),
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
                            color: context.bgInput.withAlpha(150),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: context.borderWhite10,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            PhosphorIconsRegular.magnifyingGlass,
                            color: context.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => context.push('/settings'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.bgInput.withAlpha(150),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: context.borderWhite10,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            PhosphorIconsRegular.gearSix,
                            color: context.textSecondary,
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
            color: context.textPrimary,
            height: 1.05,
            letterSpacing: -1.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Scan something to discover\nwhat\'s really inside.',
          style: TextStyle(
            fontSize: 16,
            color: context.textSecondary,
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
            padding: EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: context.bgInput.withAlpha(102),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: context.accentMint.withAlpha(25),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.accentMint.withAlpha(13),
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
                    color: context.accentMint.withAlpha(25),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.accentMint.withAlpha(38),
                        blurRadius: 30,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Icon(
                    PhosphorIconsFill.scan,
                    color: context.accentMint,
                    size: 36,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Scan a Product',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap to open camera and analyze\nany food product instantly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textSecondary,
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
            context,
            icon: PhosphorIconsRegular.clockCounterClockwise,
            label: 'History',
            color: context.accentCyan,
            onTap: () => context.go('/history'),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildQuickAction(
            context,
            icon: PhosphorIconsRegular.magnifyingGlass,
            label: 'Search',
            color: context.accentMint,
            onTap: () {
              showSearch(context: context, delegate: _ProductSearchDelegate());
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildQuickAction(
            context,
            icon: PhosphorIconsRegular.chatCircleDots,
            label: 'Reviews',
            color: context.accentGold,
            onTap: () => context.push('/reviews'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
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
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: context.bgInput.withAlpha(102),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withAlpha(25), width: 1.0),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                SizedBox(height: 8),
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

  Widget _buildTrendingSwapsSection(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingProductsProvider);

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
                color: context.textPrimary,
              ),
            ),
            Text(
              'CURATED\nFOR YOU',
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
        trendingAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return Text(
                'No trending products available.',
                style: TextStyle(color: context.textSecondary),
              );
            }
            return Column(
              children: products.map((p) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: _buildSwapCard(
                    context: context,
                    id: p['id'].toString(),
                    name: p['product_name'] ?? 'Unknown Item',
                    category: p['health_category'] ?? 'Eatable',
                    score: (p['health_score'] as num?)?.toDouble() ?? 5.0,
                  ),
                );
              }).toList(),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(color: context.accentMint),
          ),
          error: (error, stack) => Text(
            'Error loading top swaps: $error',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildSwapCard({
    required BuildContext context,
    required String id,
    required String name,
    required String category,
    required double score,
  }) {
    return GestureDetector(
      onTap: () => context.push('/product-detail/$id'),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(77),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: context.bgInput,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                DynamicIconMapper.getIconForProduct(name),
                color: context.textSecondary,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.accentMint.withAlpha(51),
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.accentMint.withAlpha(77),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  score.toStringAsFixed(1),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: context.accentMint,
                  ),
                ),
              ),
            ),
          ],
        ),
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
      appBarTheme: AppBarTheme(backgroundColor: context.bgScreen, elevation: 0),
      scaffoldBackgroundColor: context.bgScreen,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: context.textSecondary),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, color: context.textSecondary),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: context.accentMint),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _SearchResults(query: query);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 2) {
      return Container(
        color: context.bgScreen,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PhosphorIconsRegular.magnifyingGlass,
                color: context.textSecondary.withAlpha(100),
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Search for any food product',
                style: TextStyle(
                  color: context.textSecondary.withAlpha(150),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'e.g. "Chocolate", "Green Tea", "Yogurt"',
                style: TextStyle(
                  color: context.textSecondary.withAlpha(100),
                  fontSize: 13,
                ),
              ),
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
      color: context.bgScreen,
      child: resultsAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: context.accentMint)),
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: TextStyle(color: context.textSecondary),
          ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Text(
                'No products found for "$query"',
                style: TextStyle(color: context.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        ? context.accentMint
        : score >= 4.5
        ? context.accentCyan
        : Color(0xFFFF5252);

    return GestureDetector(
      onTap: () => context.push('/product-detail/$id'),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: context.bgInput,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                PhosphorIconsRegular.forkKnife,
                color: context.textSecondary,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (category.isNotEmpty)
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 13,
                        color: scoreColor.withAlpha(180),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scoreColor.withAlpha(51),
                shape: BoxShape.circle,
                border: Border.all(color: scoreColor.withAlpha(77), width: 1.0),
              ),
              child: Center(
                child: Text(
                  score.toStringAsFixed(1),
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: scoreColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
