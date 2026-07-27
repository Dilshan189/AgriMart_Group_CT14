class RequestModel {
  final String id;
  final String productId;
  final String productName;
  final String buyerId;
  final String buyerName;
  final String farmerId;
  final String farmerName;
  final double quantity;
  final double totalPrice;
  final String status; // 'pending', 'accepted', 'rejected'
  final String deliveryType; // 'pickup', 'delivery'
  final String note;
  final DateTime createdAt;

  RequestModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.buyerId,
    required this.buyerName,
    required this.farmerId,
    required this.farmerName,
    required this.quantity,
    required this.totalPrice,
    this.status = 'pending',
    required this.deliveryType,
    required this.note,
    required this.createdAt,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RequestModel(
      id: documentId,
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      farmerId: map['farmerId'] ?? '',
      farmerName: map['farmerName'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      deliveryType: map['deliveryType'] ?? 'pickup',
      note: map['note'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': status,
      'deliveryType': deliveryType,
      'note': note,
      'createdAt': createdAt,
    };
  }
}
