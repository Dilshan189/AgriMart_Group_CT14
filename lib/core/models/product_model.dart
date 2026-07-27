class ProductModel {
  final String id;
  final String farmerId;
  final String farmerName;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final String location;
  final String description;
  final String status; // 'active', 'pending', 'flagged'
  final double price; // adding price as it was in UI
  final DateTime createdAt;
  final String? imageUrl;

  ProductModel({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.location,
    required this.description,
    this.status = 'pending',
    required this.price,
    required this.createdAt,
    this.imageUrl,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      farmerId: map['farmerId'] ?? '',
      farmerName: map['farmerName'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'kg',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      price: (map['price'] ?? 0).toDouble(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmerId': farmerId,
      'farmerName': farmerName,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'location': location,
      'description': description,
      'status': status,
      'price': price,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
    };
  }
}
