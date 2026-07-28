import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/open_request_model.dart';
import 'auth_provider.dart';

class OpenRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOpenRequest(OpenRequestModel request) async {
    final docRef = _firestore.collection('open_requests').doc();
    final data = request.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  Stream<List<OpenRequestModel>> getOpenRequests() {
    return _firestore
        .collection('open_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OpenRequestModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<OpenRequestModel>> getBuyerOpenRequests(String buyerId) {
    return _firestore
        .collection('open_requests')
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs;
      docs.sort((a, b) {
        final aTime = (a.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final bTime = (b.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        return bTime.compareTo(aTime);
      });
      return docs
          .map((doc) => OpenRequestModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}

final openRequestRepositoryProvider = Provider<OpenRequestRepository>((ref) {
  return OpenRequestRepository();
});

class OpenRequestController extends StateNotifier<AsyncValue<void>> {
  final OpenRequestRepository _repository;

  OpenRequestController(this._repository) : super(const AsyncValue.data(null));

  Future<void> submitRequest(OpenRequestModel request) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addOpenRequest(request);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final openRequestControllerProvider =
    StateNotifierProvider<OpenRequestController, AsyncValue<void>>((ref) {
  return OpenRequestController(ref.watch(openRequestRepositoryProvider));
});

final buyerOpenRequestsProvider = StreamProvider<List<OpenRequestModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return ref.watch(openRequestRepositoryProvider).getBuyerOpenRequests(user.uid);
  }
  return Stream.value([]);
});

final allOpenRequestsProvider = StreamProvider<List<OpenRequestModel>>((ref) {
  return ref.watch(openRequestRepositoryProvider).getOpenRequests();
});
