import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scan_history_model.dart';
import 'auth_provider.dart';

/// Provides the user's scan history from the backend.
/// Supports refresh and pagination.
final scanHistoryProvider =
    AsyncNotifierProvider<ScanHistoryNotifier, List<ScanHistoryModel>>(
        ScanHistoryNotifier.new);

class ScanHistoryNotifier extends AsyncNotifier<List<ScanHistoryModel>> {
  @override
  Future<List<ScanHistoryModel>> build() async {
    return _fetchHistory();
  }

  Future<List<ScanHistoryModel>> _fetchHistory({int limit = 50, int offset = 0}) async {
    final token = ref.read(authTokenProvider);
    if (token == null) return [];

    final api = ref.read(apiClientProvider);
    return api.getHistory(token: token, limit: limit, offset: offset);
  }

  /// Pull-to-refresh or re-fetch after a new scan.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchHistory());
  }

  /// Load more history items for infinite scroll.
  Future<void> loadMore() async {
    final current = state.value ?? [];
    final more = await _fetchHistory(offset: current.length);
    state = AsyncData([...current, ...more]);
  }
}
