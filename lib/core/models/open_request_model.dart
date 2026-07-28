import 'package:cloud_firestore/cloud_firestore.dart';

class OpenRequestModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String category;
  final String productName;
  final double quantity;
  final double expectedPrice;
  final String location;
  final String description;
  final String status; // 'active', 'fulfilled', 'cancelled'
  final DateTime createdAt;

  OpenRequestModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.category,
    required this.productName,
    required this.quantity,
    required this.expectedPrice,
    required this.location,
    required this.description,
    this.status = 'active',
    required this.createdAt,
  });

  factory OpenRequestModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OpenRequestModel(
      id: documentId,
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      category: map['category'] ?? '',
      productName: map['productName'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      expectedPrice: (map['expectedPrice'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'active',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'buyerName': buyerName,
      'category': category,
      'productName': productName,
      'quantity': quantity,
      'expectedPrice': expectedPrice,
      'location': location,
      'description': description,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
