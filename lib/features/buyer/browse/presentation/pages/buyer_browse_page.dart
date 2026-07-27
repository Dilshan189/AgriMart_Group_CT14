import 'package:flutter/material.dart';

class BuyerBrowsePage extends StatelessWidget {
  const BuyerBrowsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
          onPressed: () {
            // Since it's in a bottom nav, back might not make sense, but keeping it for UI accuracy
          },
        ),
        title: const Text(
          'All Products',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('ALL', isSelected: true),
                  const SizedBox(width: 8),
                  _buildFilterChip('🍎 Fruits'),
                  const SizedBox(width: 8),
                  _buildFilterChip('🥦 Vegetables'),
                  const SizedBox(width: 8),
                  _buildFilterChip('🌾 Grains'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Result count
            Text(
              'Showing 12 products near you',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),

            // Product List
            _buildProductCard(
              title: 'Organic Spinach',
              details: '50 kg · Rs.120/kg · Colombo',
              farmer: '🧑‍🌾 Kumarasinghe',
              status: 'In Stock',
              statusColor: const Color(0xFFEDF5E1),
              statusTextColor: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 12),
            
            _buildProductCard(
              title: 'Fresh Tomatoes',
              details: '80 kg · Rs.95/kg · Gampaha',
              farmer: '🧑‍🌾 Ahamed N.',
              status: 'In Stock',
              statusColor: const Color(0xFFEDF5E1),
              statusTextColor: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 12),
            
            _buildProductCard(
              title: 'Carrots',
              details: '40 kg · Rs.85/kg · Kandy',
              farmer: '🧑‍🌾 Sandeepa K.',
              status: 'In Stock',
              statusColor: const Color(0xFFEDF5E1),
              statusTextColor: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 12),

            _buildProductCard(
              title: 'Ripe Bananas',
              details: '60 kg · Rs.60/kg · Matara',
              farmer: '🧑‍🌾 Gunathilaka',
              status: 'Low Stock',
              statusColor: const Color(0xFFFFF3E0), // Light orange
              statusTextColor: const Color(0xFFE65100), // Dark orange
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String title,
    required String details,
    required String farmer,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Light green tint
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  farmer,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
