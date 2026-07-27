import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new product
  Future<void> addProduct(ProductModel product) async {
    final docRef = _firestore.collection('products').doc();
    final data = product.toMap();
    data['createdAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  // Edit a product
  Future<void> updateProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.id).update(product.toMap());
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  // Get stream of all products (for buyer/officer)
  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Get stream of products for a specific farmer
  Stream<List<ProductModel>> getProductsByFarmer(String farmerId) {
    return _firestore.collection('products')
      .where('farmerId', isEqualTo: farmerId)
      .snapshots()
      .map((snapshot) {
        final docs = snapshot.docs;
        docs.sort((a, b) {
          final aTime = (a.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          final bTime = (b.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          return bTime.compareTo(aTime);
        });
        return docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
      });
  }
}
