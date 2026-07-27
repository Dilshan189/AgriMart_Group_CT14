class RequestModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String? productId; // null if it's a general request
  final String requestedProduct;
  final double quantity;
  final String unit;
  final String preferredLocation;
  final String additionalNotes;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;

  RequestModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    this.productId,
    required this.requestedProduct,
    required this.quantity,
    required this.unit,
    required this.preferredLocation,
    required this.additionalNotes,
    this.status = 'pending',
    required this.createdAt,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RequestModel(
      id: documentId,
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      productId: map['productId'],
      requestedProduct: map['requestedProduct'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'kg',
      preferredLocation: map['preferredLocation'] ?? '',
      additionalNotes: map['additionalNotes'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'buyerName': buyerName,
      'productId': productId,
      'requestedProduct': requestedProduct,
      'quantity': quantity,
      'unit': unit,
      'preferredLocation': preferredLocation,
      'additionalNotes': additionalNotes,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
