import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nutrinfo_app/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../providers/auth_provider.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isProcessing = false;
  String _statusMessage = 'Point camera at a product label';
  List<Map<String, dynamic>> _foundProducts = [];
  bool _showResults = false;

  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _statusMessage = 'No camera found');
        return;
      }

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      setState(() => _statusMessage = 'Camera error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _captureAndRecognize() async {
    if (_cameraController == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Reading product label...';
    });

    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final fullText = recognizedText.text.trim();
      if (fullText.isEmpty) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'No text found. Try again.';
        });
        return;
      }

      // Extract the most prominent text (first few lines, likely the product name)
      final lines = recognizedText.blocks
          .expand((block) => block.lines)
          .map((line) => line.text.trim())
          .where((line) => line.length > 2)
          .toList();

      if (lines.isEmpty) {
        setState(() {
          _isProcessing = false;
          _statusMessage = 'No readable text. Try again.';
        });
        return;
      }

      // Use first 2-3 lines as the search query (usually the product name)
      final searchQuery = lines.take(3).join(' ');

      setState(() {
        _statusMessage = 'Searching: "${lines.first}"...';
      });

      // Query backend
      final api = ref.read(apiClientProvider);
      final result = await api.scanByName(searchQuery);

      if (result['found'] == true && result['products'] != null) {
        final products = (result['products'] as List)
            .cast<Map<String, dynamic>>();
        setState(() {
          _foundProducts = products;
          _showResults = true;
          _isProcessing = false;
        });
      } else {
        setState(() {
          _isProcessing = false;
          _statusMessage =
              result['message'] ??
              'Product nutrition info has not been updated yet.';
          _showResults = false;
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isInitialized && _cameraController != null)
            Positioned.fill(
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _cameraController!.value.previewSize?.height ?? 1,
                    height: _cameraController!.value.previewSize?.width ?? 1,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            ),

          // Dark overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(180),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withAlpha(220),
                  ],
                  stops: [0.0, 0.2, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Scan frame overlay
          if (!_showResults)
            Center(
              child: Container(
                width: 280,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.accentMint.withAlpha(150),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    // Corner accents
                    ..._buildCornerAccents(),
                    // Center text
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isProcessing
                                ? PhosphorIconsFill.circleNotch
                                : PhosphorIconsFill.textT,
                            color: context.accentMint,
                            size: 36,
                          ),
                          SizedBox(height: 8),
                          Text(
                            _isProcessing ? 'Analyzing...' : 'Product Label',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.accentMint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(120),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      'SCAN PRODUCT',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),

          // Bottom section — status + capture button OR results
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _showResults ? _buildResultsPanel() : _buildCapturePanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildCapturePanel() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A).withAlpha(220),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                color: context.accentMint.withAlpha(30),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: context.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24),
              // Capture button
              GestureDetector(
                onTap: _isProcessing ? null : _captureAndRecognize,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isProcessing
                        ? Color(0xFF333333)
                        : context.accentMint,
                    boxShadow: _isProcessing
                        ? []
                        : [
                            BoxShadow(
                              color: context.accentMint.withAlpha(80),
                              blurRadius: 24,
                              spreadRadius: -4,
                            ),
                          ],
                  ),
                  child: _isProcessing
                      ? Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: context.accentMint,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          PhosphorIconsFill.camera,
                          color: Colors.black,
                          size: 32,
                        ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                _isProcessing ? 'Reading...' : 'Tap to scan',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: context.textSecondary,
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsPanel() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A).withAlpha(240),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Found ${_foundProducts.length} match${_foundProducts.length > 1 ? 'es' : ''}',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.accentMint,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showResults = false;
                        _foundProducts = [];
                        _statusMessage = 'Point camera at a product label';
                      });
                    },
                    child: Text(
                      'Scan Again',
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _foundProducts.length,
                  itemBuilder: (context, index) {
                    final p = _foundProducts[index];
                    final score =
                        (p['health_score'] as num?)?.toDouble() ?? 5.0;
                    final name = p['product_name'] as String? ?? 'Unknown';
                    final id = p['id'] as int? ?? 0;
                    final scoreColor = score >= 7
                        ? context.accentMint
                        : score >= 4.5
                        ? context.accentCyan
                        : Color(0xFFFF5252);

                    return GestureDetector(
                      onTap: () => context.push('/product-detail/$id'),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Color(0xFF242424),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: context.bgInput,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                PhosphorIconsRegular.forkKnife,
                                color: context.textSecondary,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name,
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: scoreColor.withAlpha(40),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: scoreColor.withAlpha(80),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  score.toStringAsFixed(1),
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCornerAccents() {
    const cornerSize = 24.0;
    final color = context.accentMint;
    return [
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: 3),
              left: BorderSide(color: color, width: 3),
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: 3),
              right: BorderSide(color: color, width: 3),
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: 3),
              left: BorderSide(color: color, width: 3),
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: 3),
              right: BorderSide(color: color, width: 3),
            ),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
          ),
        ),
      ),
    ];
  }
}
