import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../theme/app_theme.dart';
import '../../core/widgets/shimmer_network_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // 1. Scrollable Main Content
          ListView(
            padding: const EdgeInsets.only(top: 120, bottom: 120, left: 24.0, right: 24.0),
            children: [
              // Search Bar — glass-panel: bg white/3%, blur 24, border white/5%
              GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: _ProductSearchDelegate(),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(8), // 3% white
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withAlpha(13), width: 1.0), // 5% white
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: const Color(0xFFB9CBB8).withAlpha(153)), // on-surface-variant/60
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Search product, brand, ingredient...',
                              style: TextStyle(
                                color: const Color(0xFFB9CBB8).withAlpha(102), // on-surface-variant/40
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Recent Scans Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Scans',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3, // tracking-tight
                      color: const Color(0xFFE5E2E1),
                    ),
                  ),
                  Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB9CBB8).withAlpha(153), // on-surface-variant opacity-60
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recent Scans Horizontal Carousel
              SizedBox(
                height: 175,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    _buildRecentScanCard(
                      title: 'Organic Almond Milk',
                      subtitle: 'Unsweetened · 32 fl oz',
                      score: '8.4',
                      isHealthy: true,
                      tag: 'No Added Sugar',
                      imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
                    ),
                    const SizedBox(width: 16),
                    _buildRecentScanCard(
                      title: 'Neon Energy Blast',
                      subtitle: 'Citrus Rush · 16 fl oz',
                      score: '2.4',
                      isHealthy: false,
                      tag: 'High Additives',
                      imageUrl: 'https://images.unsplash.com/photo-1622543925917-763c34d1a86e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Trending Swap Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending Swap',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                      color: const Color(0xFFE5E2E1),
                    ),
                  ),
                  const Text(
                    'WEEKLY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00FF7F), // primary-container
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Trending Swap Card — glass-panel: bg white/3%, blur 24, border white/5%
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(8), // 3% white
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withAlpha(13), width: 1.0), // 5% white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Bad Product (desaturated)
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white.withAlpha(13), width: 1.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                                    child: Opacity(
                                      opacity: 0.6,
                                      child: ShimmerNetworkImage(
                                        imageUrl: 'https://images.unsplash.com/photo-1521483451569-e33803c0330c?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Cereal',
                                style: TextStyle(fontSize: 10, color: Color(0xFFB9CBB8), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '3.2',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFFB4AB)),
                              ),
                            ],
                          ),
                        ),
                        // Arrow — simple east arrow at 30% opacity
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.east,
                            size: 20,
                            color: const Color(0xFFB9CBB8).withAlpha(77), // on-surface-variant/30
                          ),
                        ),
                        // Good Product
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.neonMint.withAlpha(51), width: 1.0), // primary-container/20
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.neonMint.withAlpha(51), // neo-glow: 0 0 15px rgba(0,255,127,0.2)
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: const ShimmerNetworkImage(
                                    imageUrl: 'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Oats',
                                style: TextStyle(fontSize: 10, color: Color(0xFF00FF7F), fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '9.2',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00FF7F)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. Fixed Header — Reference: bg-[#121212]/80 backdrop-blur-2xl, no aurora blobs
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                child: Container(
                  color: const Color(0xFF121212).withAlpha(204), // 80% opacity
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Good morning, Alex.',
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE5E2E1),
                              letterSpacing: -0.3, // tracking-tight
                            ),
                          ),
                          Row(
                            children: [
                              // PRO Badge — Reference: bg-primary-container text-on-primary neo-glow
                              // Solid mint green bg, dark green text
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00FF7F), // primary-container solid
                                  borderRadius: BorderRadius.circular(9999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.neonMint.withAlpha(51), // neo-glow: 0 0 15px rgba(0,255,127,0.2)
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'PRO',
                                  style: TextStyle(
                                    color: Color(0xFF003917), // on-primary
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Profile Avatar — Reference: border-outline-variant (#3b4b3c)
                              GestureDetector(
                                onTap: () => context.push('/profile'),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF3B4B3C), width: 1.0),
                                  ),
                                  child: const ClipOval(
                                    child: ShimmerNetworkImage(
                                      imageUrl: "https://ui-avatars.com/api/?name=Alex&background=random&size=100",
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScanCard({
    required String title,
    required String subtitle,
    required String score,
    required bool isHealthy,
    required String tag,
    required String imageUrl,
  }) {
    // Reference score badge colors:
    // Healthy: bg-primary-container(#00FF7F) text-on-primary(#003917) — solid
    // Unhealthy: bg-error(#FFB4AB) text-on-error(#690005) — solid
    final scoreBg = isHealthy ? const Color(0xFF00FF7F) : const Color(0xFFFFB4AB);
    final scoreText = isHealthy ? const Color(0xFF003917) : const Color(0xFF690005);
    final tagColor = isHealthy ? const Color(0xFF00FF7F) : const Color(0xFFFFB4AB);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
        child: Container(
          width: 256,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1B1B).withAlpha(127), // surface-container-low/50
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(13), width: 1.0), // white/5%
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image — w-12 h-12 rounded-xl
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF353534), // surface-container-highest
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ShimmerNetworkImage(imageUrl: imageUrl),
                    ),
                  ),
                  // Score badge — w-8 h-8 rounded-full, solid bg
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: scoreBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        score,
                        style: TextStyle(
                          color: scoreText,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE5E2E1),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFB9CBB8),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    isHealthy ? PhosphorIconsFill.checkCircle : PhosphorIconsFill.warning,
                    size: 14,
                    color: tagColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tag.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: tagColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Search delegate for product search — themed to match the app's dark UI
class _ProductSearchDelegate extends SearchDelegate<String> {
  _ProductSearchDelegate() : super(searchFieldLabel: 'Search product, brand, ingredient...');

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF131313),
        foregroundColor: Color(0xFFE5E2E1),
        elevation: 0,
      ),
      scaffoldBackgroundColor: const Color(0xFF131313),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: const Color(0xFFB9CBB8).withAlpha(102)),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Color(0xFFE5E2E1), fontSize: 16),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Color(0xFFB9CBB8)),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF00FF7F)),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: const Color(0xFF131313),
      child: Center(
        child: Text(
          'Results for "$query"',
          style: const TextStyle(color: Color(0xFFB9CBB8), fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = ['Doritos Nacho Cheese', 'Greek Yogurt', 'Almond Milk', 'Whole Grain Bread', 'Kombucha']
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFF131313),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(PhosphorIconsRegular.magnifyingGlass, color: Color(0xFFB9CBB8), size: 18),
            title: Text(
              suggestions[index],
              style: const TextStyle(color: Color(0xFFE5E2E1)),
            ),
            onTap: () {
              query = suggestions[index];
              showResults(context);
            },
          );
        },
      ),
    );
  }
}
