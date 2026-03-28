import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_client.dart';

// ── Auth0 Configuration ──────────────────────────────────────────────────────
const _auth0Domain = 'dev-q61utsgndptw7t83.us.auth0.com';
const _auth0ClientId = 'MN6hePSprRHKuD7GN3QwHD7g9EUD0hwN';

/// Singleton Auth0 SDK instance.
final auth0Provider = Provider<Auth0>((ref) {
  return Auth0(_auth0Domain, _auth0ClientId);
});

/// Provides the singleton ApiClient instance.
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

/// Stores the current Auth0 credentials (access token, ID token, user profile).
/// Null when signed out. Uses Notifier since StateProvider is removed in Riverpod 3.x.
final auth0CredentialsProvider =
    NotifierProvider<Auth0CredentialsNotifier, Credentials?>(
        Auth0CredentialsNotifier.new);

class Auth0CredentialsNotifier extends Notifier<Credentials?> {
  @override
  Credentials? build() => null;

  void setCredentials(Credentials? creds) {
    state = creds;
  }

  void clear() {
    state = null;
  }
}

/// Provides the current access token string for API calls.
/// Returns null if not authenticated.
final authTokenProvider = Provider<String?>((ref) {
  final creds = ref.watch(auth0CredentialsProvider);
  return creds?.accessToken;
});

/// Auth state notifier — handles user sync with backend after Auth0 login.
final currentUserProvider =
    AsyncNotifierProvider<CurrentUserNotifier, UserModel?>(
        CurrentUserNotifier.new);

class CurrentUserNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final token = ref.watch(authTokenProvider);
    if (token == null) return null;

    final creds = ref.read(auth0CredentialsProvider);
    if (creds == null) return null;

    final api = ref.read(apiClientProvider);
    try {
      return await api.syncUser(
        token: token,
        displayName: creds.user.name,
        email: creds.user.email,
        dietaryFocus: 'None',
      );
    } catch (e) {
      // Backend may be unreachable — return a local-only user so the app
      // continues working (features requiring the backend will fail gracefully).
      debugPrint('Backend sync failed: $e');
      return UserModel(
        id: creds.user.sub,
        displayName: creds.user.name ?? 'User',
        email: creds.user.email ?? '',
        dietaryFocus: 'None',
      );
    }
  }

  /// Call after onboarding to update dietary focus.
  Future<void> updateDietaryFocus(String focus) async {
    final token = ref.read(authTokenProvider);
    if (token == null) return;

    final creds = ref.read(auth0CredentialsProvider);
    if (creds == null) return;

    final api = ref.read(apiClientProvider);
    final updated = await api.syncUser(
      token: token,
      displayName: creds.user.name,
      email: creds.user.email,
      dietaryFocus: focus,
    );
    state = AsyncData(updated);
  }

  /// Sign out of Auth0 and clear user state.
  Future<void> signOut() async {
    final auth0 = ref.read(auth0Provider);
    final webAuth = kIsWeb
        ? auth0.webAuthentication()
        : auth0.webAuthentication(scheme: 'com.nutrinfo.app');
    await webAuth.logout();
    ref.read(auth0CredentialsProvider.notifier).clear();
    state = const AsyncData(null);
  }
}
