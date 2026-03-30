import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';

/// Provides the singleton ApiClient instance.
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
