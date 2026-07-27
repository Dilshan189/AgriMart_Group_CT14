import 'dart:ui' as BorderType;

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class BuyerHomeContent extends StatelessWidget {
  const BuyerHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Find Fresh Produce',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search products, farmers...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('ALL', isSelected: true),
                const SizedBox(width: 8),
                _buildCategoryChip('🍅 Fruits'),
                const SizedBox(width: 8),
                _buildCategoryChip('🥦 Vegetables'),
                const SizedBox(width: 8),
                _buildCategoryChip('🌾 Grains'),
                const SizedBox(width: 8),
                _buildCategoryChip('🌿 Herbs'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Nearby Farmers Section
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: Colors.green.shade300,
              strokeWidth: 1.5,
              dashPattern: const [6, 4],
              radius: const Radius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4EF), // Light green tint
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('🗺️', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text(
                    'Nearby Farmers — Colombo District',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Featured Products Title
          const Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Products List
          _buildProductCard(
            name: 'Organic Spinach',
            farmer: 'Kumarasinghe',
            location: 'Colombo',
            price: 'Rs. 120/kg',
            isAvailable: true,
          ),
          const SizedBox(height: 12),
          _buildProductCard(
            name: 'Fresh Tomatoes',
            farmer: 'Ahamed N.',
            location: 'Gampaha',
            price: 'Rs. 95/kg',
            isAvailable: true,
          ),
          const SizedBox(height: 12),
          _buildProductCard(
            name: 'Carrots',
            farmer: 'Sandeepa K.',
            location: 'Kandy',
            price: 'Rs. 95/kg',
            isAvailable: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String farmer,
    required String location,
    required String price,
    required bool isAvailable,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4EF),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isAvailable ? 'Available' : 'Low Stock',
                        style: TextStyle(
                          color: isAvailable ? Colors.green.shade700 : Colors.orange.shade800,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('🧑‍🌾', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      farmer,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 12, color: Colors.grey.shade600),
                    const SizedBox(width: 2),
                    Text(
                      location,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 14,
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
