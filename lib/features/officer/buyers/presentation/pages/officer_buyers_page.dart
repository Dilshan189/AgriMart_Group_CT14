import 'package:flutter/material.dart';

class OfficerBuyersPage extends StatelessWidget {
  const OfficerBuyersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF8D5A36), // Brown
        elevation: 0,
        title: const Text(
          'Manage Buyers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Color(0xFF8D5A36), size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Text(
              'Agricultural Officer — Zone 3 Overview',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),

            // Top Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '57',
                    'Total',
                    bgColor: Colors.blue.shade50,
                    borderColor: Colors.blue.shade200,
                    textColor: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    '52',
                    'Active',
                    bgColor: const Color(0xFFEDF5E1),
                    borderColor: const Color(0xFFC5E1A5),
                    textColor: const Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    '143', // Based on screenshot (even though Suspended is 5 in chips)
                    'Suspended',
                    bgColor: Colors.red.shade50,
                    borderColor: Colors.red.shade100,
                    textColor: Colors.brown.shade800, // Using dark brown as per screenshot
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search buyers...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
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
                  _buildFilterChip('All(57)', isSelected: true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active (52)'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Suspended (5)'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Top Buyers
            const Text(
              'Top Buyers',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildBuyerCard(
              name: 'Ahamed N.A.M.',
              details: 'Gampaha · 6 orders placed',
              isTopBuyer: true,
            ),
            const SizedBox(height: 24),

            // All Buyers
            const Text(
              'All Buyers',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildBuyerCard(
              name: 'Sandeepa K.H.',
              details: 'Colombo · 4 orders',
            ),
            const SizedBox(height: 12),
            _buildBuyerCard(
              name: 'Gunathilaka K.M.T.K.S',
              details: 'Kandy · 2 orders',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label, {
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.orange.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.brown.shade800 : Colors.grey.shade500,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBuyerCard({required String name, required String details, bool isTopBuyer = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🛒', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isTopBuyer ? Colors.blue.shade50 : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isTopBuyer ? 'Top Buyer' : 'Active',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isTopBuyer ? Colors.blue.shade700 : const Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
