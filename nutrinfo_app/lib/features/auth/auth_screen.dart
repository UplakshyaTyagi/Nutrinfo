import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
  }

  /// Auth0 Universal Login — opens the Auth0 login page in a browser/web view.
  /// For "Sign Up" mode, sets the `screen_hint` parameter to show registration.
  Future<void> _handleAuth0Login() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final auth0 = ref.read(auth0Provider);
      final webAuth = kIsWeb
          ? auth0.webAuthentication()
          : auth0.webAuthentication(scheme: 'com.nutrinfo.app');
      final creds = await webAuth.login(
        scopes: {'openid', 'profile', 'email', 'offline_access'},
        parameters: _isLogin ? {} : {'screen_hint': 'signup'},
      );

      // Store credentials in provider
      ref.read(auth0CredentialsProvider.notifier).setCredentials(creds);

      // Sync with backend
      ref.invalidate(currentUserProvider);
      if (mounted) context.go('/onboarding');
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('CANCELLED') || msg.contains('user cancelled')) {
        // User dismissed the login — not an error
      } else {
        debugPrint('Auth0 Login Error: $e');
        setState(() => _errorMessage = 'Auth failed: $msg');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Auth0 login with Google connection hint — opens directly to Google sign-in.
  Future<void> _handleGoogleSignIn() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final auth0 = ref.read(auth0Provider);
      final webAuth = kIsWeb
          ? auth0.webAuthentication()
          : auth0.webAuthentication(scheme: 'com.nutrinfo.app');
      final creds = await webAuth.login(
        scopes: {'openid', 'profile', 'email', 'offline_access'},
        parameters: {'connection': 'google-oauth2'},
      );

      // Store credentials in provider
      ref.read(auth0CredentialsProvider.notifier).setCredentials(creds);

      // Sync with backend
      ref.invalidate(currentUserProvider);
      if (mounted) context.go('/onboarding');
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('CANCELLED') || msg.contains('user cancelled')) {
        // User dismissed — not an error
      } else {
        debugPrint('Google Auth Error: $e');
        setState(() => _errorMessage = 'Google failed: $msg');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.background, Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title Header
                    Hero(
                      tag: 'app_logo',
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 80,
                          color: AppTheme.neonMint,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isLogin ? 'Welcome Back' : 'Join Nutrinfo',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin ? 'Sign in to access your nutritional insights.' : 'Create an account to start scanning.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Glassmorphic Auth Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceGlass,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppTheme.cyanAccent.withAlpha(50),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.cyanAccent.withAlpha(20),
                                blurRadius: 30,
                                spreadRadius: -5,
                              )
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Sign In / Sign Up Button — Opens Auth0 Universal Login
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [AppTheme.neonMint, AppTheme.cyanAccent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.neonMint.withAlpha(100),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    )
                                  ]
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleAuth0Login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20, height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2, color: AppTheme.background),
                                        )
                                      : Text(
                                          _isLogin ? 'Sign In' : 'Sign Up',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.background,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                ),
                              ),
                              
                              // Error message
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Color(0xFFFF5252), fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              
                              const SizedBox(height: 24),
                              
                              // Or Divider
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.white.withAlpha(50))),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text('OR', style: TextStyle(color: Colors.white54, fontSize: 12)),
                                  ),
                                  Expanded(child: Divider(color: Colors.white.withAlpha(50))),
                                ],
                              ),
                              const SizedBox(height: 24),
                              
                              // Google Button (Glassmorphic)
                              OutlinedButton.icon(
                                onPressed: _isLoading ? null : _handleGoogleSignIn,
                                icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 28),
                                label: const Text(
                                  'Continue with Google',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.white.withAlpha(10),
                                  side: BorderSide(color: Colors.white.withAlpha(50)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Toggle Mode
                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(
                        _isLogin 
                          ? "Don't have an account? Sign Up" 
                          : "Already have an account? Sign In",
                        style: const TextStyle(
                          color: AppTheme.neonMint,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
