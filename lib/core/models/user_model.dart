class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'farmer', 'buyer', 'officer'
  final String? phone;
  final String? district;
  final String? nic;
  final String status; // 'pending', 'approved', 'suspended'
  final List<String> savedProducts;
  final DateTime createdAt;

  final String? zone;
  final String? department;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.district,
    this.nic,
    this.status = 'approved',
    this.savedProducts = const [],
    required this.createdAt,
    this.zone,
    this.department,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'buyer',
      phone: map['phone'] ?? (map['contact'] != null && !map['contact'].toString().contains('@') ? map['contact'] : null),
      district: map['district'],
      nic: map['nic'],
      status: map['status'] ?? 'approved',
      savedProducts: List<String>.from(map['savedProducts'] ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      zone: map['zone'],
      department: map['department'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'district': district,
      'nic': nic,
      'status': status,
      'savedProducts': savedProducts,
      'createdAt': createdAt,
      'zone': zone,
      'department': department,
    };
  }
}
