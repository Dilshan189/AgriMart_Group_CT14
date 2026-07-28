import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/product_provider.dart';
import '../../../../../core/providers/request_provider.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/models/request_model.dart';

class FarmerHomeContent extends ConsumerWidget {
  const FarmerHomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final productsAsync = ref.watch(farmerProductsProvider);
    final requestsAsync = ref.watch(farmerRequestsProvider);

    final user = currentUserAsync.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Greeting
          Text(
            'Hello, Farmer ${user?.name ?? 'Unknown'}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${user?.district ?? 'Unknown'} District — Agricultural Zone 3',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),

          // Stat Cards Row
          productsAsync.when(
            data: (products) {
              final requests = requestsAsync.value ?? [];
              final pendingRequests = requests.where((r) => r.status == 'pending').length;
              final soldProducts = requests.where((r) => r.status == 'accepted').length; // Or logic based on sales

              return Row(
                children: [
                  Expanded(child: _buildStatCard(products.length.toString(), 'Product')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(pendingRequests.toString(), 'Request')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(soldProducts.toString(), 'Sold')),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
          ),
          const SizedBox(height: 20),

          // Add New Product Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/addProduct');
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Add New Product',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF387015),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // My Recent Products Section
          const Text(
            'My Recent Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: Text('No products added yet.')),
                );
              }
              return Column(
                children: products.take(3).map((p) => _buildProductCard(p)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
          ),
          const SizedBox(height: 24),

          // New Buyer Requests Section
          const Text(
            'New Buyer Requests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          requestsAsync.when(
            data: (requests) {
              final newRequests = requests.where((r) => r.status == 'pending').toList();
              if (newRequests.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: Text('No new requests.')),
                );
              }
              return Column(
                children: newRequests.take(3).map((r) => _buildRequestCard(r)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF5E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC5E1A5), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E5E16),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF387015),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    Color statusColor;
    Color statusTextColor;
    
    if (product.status == 'active') {
      statusColor = const Color(0xFFE8F5E9);
      statusTextColor = const Color(0xFF2E7D32);
    } else if (product.status == 'pending') {
      statusColor = const Color(0xFFFFF3E0);
      statusTextColor = const Color(0xFFE65100);
    } else {
      statusColor = Colors.red.shade50;
      statusTextColor = Colors.red.shade800;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFEDF5E1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.inventory, color: Color(0xFF387015)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${product.quantity}${product.unit} · ${product.category}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${product.price}/${product.unit}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: statusTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(RequestModel request) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text('👤', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request for ${request.productName}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Buyer: ${request.buyerName} · ${request.quantity} kg',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
