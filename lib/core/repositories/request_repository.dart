import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request_model.dart';

class RequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new buyer request
  Future<void> submitRequest(RequestModel request) async {
    final docRef = _firestore.collection('requests').doc();
    final data = request.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  // Edit a request
  Future<void> updateRequestStatus(String requestId, String status) async {
    await _firestore.collection('requests').doc(requestId).update({'status': status});
  }

  // Get stream of all requests (for officer)
  Stream<List<RequestModel>> getAllRequests() {
    return _firestore.collection('requests').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => RequestModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Get stream of requests for a specific buyer
  Stream<List<RequestModel>> getRequestsByBuyer(String buyerId) {
    return _firestore.collection('requests')
      .where('buyerId', isEqualTo: buyerId)
      .snapshots()
      .map((snapshot) {
        final docs = snapshot.docs;
        docs.sort((a, b) {
          final aTime = (a.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          final bTime = (b.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          return bTime.compareTo(aTime);
        });
        return docs.map((doc) => RequestModel.fromMap(doc.data(), doc.id)).toList();
      });
  }
}
