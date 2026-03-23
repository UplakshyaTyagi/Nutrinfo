import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../theme/app_theme.dart';
import '../../core/widgets/shimmer_network_image.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with TickerProviderStateMixin {
  late final AnimationController _scanLineController;
  late final AnimationController _pulseController;
  late final MobileScannerController _cameraController;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _pulseController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.85;
    final boxHeight = boxWidth * 1.25; // aspect-ratio 4:5

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Stack(
        children: [
          // 1. Camera Viewfinder Background
          Positioned.fill(
            child: MobileScanner(
              controller: _cameraController,
              onDetect: (capture) {
                // Barcode detection handler — will be wired to API later
              },
            ),
          ),

          // 2. Vignette Overlay — radial-gradient(circle, transparent 30%, rgba(13,13,13,0.8) 100%)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0D0D0D).withAlpha(204), // 80%
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
          ),

          // 3. Top Header Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Close button + Nutrinfo branding
                    Row(
                      children: [
                        // Close button — glass-morphism: bg rgba(42,42,42,0.4), blur 16px, border white/10%
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9999),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A).withAlpha(102), // rgba(42,42,42,0.4)
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withAlpha(25), // white/10%
                                    width: 1.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFFE5E2E1),
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Nutrinfo branding
                        Text(
                          'Nutrinfo',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF00FF7F),
                            letterSpacing: -0.5, // tracking-tighter
                          ),
                        ),
                      ],
                    ),
                    // Right: PRO badge + Profile avatar
                    Row(
                      children: [
                        // PRO pill — glass-morphism with mint text
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9999),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A).withAlpha(102),
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(
                                  color: const Color(0xFF00FF7F).withAlpha(51), // #00FF7F/20
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                'PRO',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF00FF7F),
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Profile avatar — 40x40, border-2 #00FF7F, shadow glow
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00FF7F),
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FF7F).withAlpha(77), // rgba(0,255,127,0.3)
                                blurRadius: 10,
                              ),
                            ],
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

          // 4. Center: AR Bounding Box + Status Pill + Search Bar
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status Pill — "ANALYZING LABEL..."
                _buildStatusPill(),
                const SizedBox(height: 16),

                // AR Bounding Box
                SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Main container with AR glow
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF8BD5FF).withAlpha(51), // secondary/20
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00BFFF).withAlpha(77), // rgba(0,191,255,0.3)
                                blurRadius: 40,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Inner glow effect
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00BFFF).withAlpha(38), // inset rgba(0,191,255,0.15)
                                blurRadius: 30,
                                blurStyle: BlurStyle.inner,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Crosshair lines
                      Center(
                        child: SizedBox(
                          width: boxWidth * 0.8,
                          height: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFF8BD5FF).withAlpha(25), // secondary/10
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 1,
                          height: boxHeight * 0.8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFF8BD5FF).withAlpha(25),
                            ),
                          ),
                        ),
                      ),

                      // Corner Accents
                      _buildCornerAccent(Alignment.topLeft),
                      _buildCornerAccent(Alignment.topRight),
                      _buildCornerAccent(Alignment.bottomLeft),
                      _buildCornerAccent(Alignment.bottomRight),

                      // Animated Scan Line
                      AnimatedBuilder(
                        animation: _scanLineController,
                        builder: (context, child) {
                          final progress = _scanLineController.value;
                          // Fade in at start, fade out at end
                          double opacity = 1.0;
                          if (progress < 0.05) {
                            opacity = progress / 0.05;
                          } else if (progress > 0.95) {
                            opacity = (1.0 - progress) / 0.05;
                          }

                          return Positioned(
                            top: progress * (boxHeight - 2),
                            left: 0,
                            right: 0,
                            child: Opacity(
                              opacity: opacity,
                              child: Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF00BFFF),
                                      Color(0xFF00FF7F),
                                      Color(0xFF00BFFF),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Search Bar Overlay
                _buildSearchBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the "ANALYZING LABEL..." status pill with a pulsing cyan dot
  Widget _buildStatusPill() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A).withAlpha(102), // glass-morphism bg
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: const Color(0xFF00BFFF).withAlpha(77), // border-[#00BFFF]/30
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing dot
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + sin(_pulseController.value * 2 * pi) * 0.4;
                  return SizedBox(
                    width: 16,
                    height: 16,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Ping ring
                          Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF8BD5FF).withAlpha((191 * (2.0 - scale)).round()),
                              ),
                            ),
                          ),
                          // Core dot
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF8BD5FF), // secondary
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Text(
                'ANALYZING LABEL...',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE5E2E1),
                  letterSpacing: 3.0, // tracking-[0.2em]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the search bar overlay below the AR bounding box
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A).withAlpha(102), // glass-morphism
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withAlpha(25), // white/10%
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(127),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Color(0xFFB9CBB8), // on-surface-variant
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  'Search for product...',
                  style: TextStyle(
                    color: const Color(0xFFB9CBB8).withAlpha(153), // on-surface-variant/60
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a corner accent bracket at the given alignment
  Widget _buildCornerAccent(Alignment alignment) {
    const double size = 56; // w-14 h-14
    const double thickness = 4; // border-4
    const Color accentColor = Color(0xFF8BD5FF); // secondary

    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;

    final borderRadius = BorderRadius.only(
      topLeft: isTop && isLeft ? const Radius.circular(16) : Radius.zero,
      topRight: isTop && !isLeft ? const Radius.circular(16) : Radius.zero,
      bottomLeft: !isTop && isLeft ? const Radius.circular(16) : Radius.zero,
      bottomRight: !isTop && !isLeft ? const Radius.circular(16) : Radius.zero,
    );

    return Positioned(
      top: isTop ? -1 : null,
      bottom: !isTop ? -1 : null,
      left: isLeft ? -1 : null,
      right: !isLeft ? -1 : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border(
            top: isTop
                ? const BorderSide(color: accentColor, width: thickness)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: accentColor, width: thickness)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: accentColor, width: thickness)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: accentColor, width: thickness)
                : BorderSide.none,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8BD5FF).withAlpha(102), // rgba(139,213,255,0.4)
              blurRadius: 15,
            ),
          ],
        ),
      ),
    );
  }
}
