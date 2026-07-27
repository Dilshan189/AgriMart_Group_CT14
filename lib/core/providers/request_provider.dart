import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositories/request_repository.dart';
import '../models/request_model.dart';
import 'auth_provider.dart';

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepository();
});

final allRequestsProvider = StreamProvider<List<RequestModel>>((ref) {
  return ref.watch(requestRepositoryProvider).getAllRequests();
});

final buyerRequestsProvider = StreamProvider.autoDispose<List<RequestModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return ref.watch(requestRepositoryProvider).getRequestsByBuyer(user.uid);
  }
  return const Stream.empty();
});

class RequestController extends StateNotifier<AsyncValue<void>> {
  final RequestRepository _requestRepository;

  RequestController(this._requestRepository) : super(const AsyncValue.data(null));

  Future<void> submitRequest(RequestModel request) async {
    state = const AsyncValue.loading();
    try {
      await _requestRepository.submitRequest(request);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    state = const AsyncValue.loading();
    try {
      await _requestRepository.updateRequestStatus(requestId, status);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final requestControllerProvider = StateNotifierProvider<RequestController, AsyncValue<void>>((ref) {
  return RequestController(ref.watch(requestRepositoryProvider));
});
