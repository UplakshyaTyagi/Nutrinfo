import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 15))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * 2 * pi;
        
        return Stack(
          children: [
            // Blob 1: Mint overlapping top left
            Positioned(
              top: -50 + sin(t) * 30,
              left: -50 + cos(t) * 40,
              child: _buildBlob(AppTheme.neonMint.withAlpha(40), 250),
            ),
            // Blob 2: Cyan overlapping top right
            Positioned(
              top: -20 + cos(t * 1.5) * 40,
              right: -50 + sin(t * 1.5) * 30,
              child: _buildBlob(AppTheme.cyanAccent.withAlpha(40), 200),
            ),
            // Layer of intense blur rendering it into a mesh gradient
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  } // Removed BackdropFilter here because we do one massive layer blur above it
}
