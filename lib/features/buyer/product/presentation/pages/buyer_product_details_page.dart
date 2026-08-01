import 'package:flutter/material.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/router/app_router.dart';

class BuyerProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const BuyerProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    bool isAvailable = product.status == 'active';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Details',
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
            // Product Image Placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                image: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(product.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product.imageUrl == null || product.imageUrl!.isEmpty
                  ? const Center(
                      child: Icon(Icons.image, size: 64, color: Colors.grey),
                    )
                  : null,
            ),
            const SizedBox(height: 20),

            // Title and Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAvailable ? const Color(0xFFEDF5E1) : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAvailable ? 'Available' : 'Unavailable',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            
            // Price
            Text(
              'Rs. ${product.price} / ${product.unit}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E5E16),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEEEEEE), thickness: 1),
            const SizedBox(height: 16),

            // Farmer Info
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🧑‍🌾', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.farmerName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            product.location,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.message, color: Color(0xFF2E5E16)),
                  onPressed: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEEEEEE), thickness: 1),
            const SizedBox(height: 16),

            // Product Details Grid
            Row(
              children: [
                Expanded(child: _buildDetailCard('Category', product.category, '🥦')),
                const SizedBox(width: 12),
                Expanded(child: _buildDetailCard('Stock', '${product.quantity} ${product.unit}', '📦')),
              ],
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description.isNotEmpty ? product.description : 'No description provided.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 40),

            // Request Action Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context, 
                    AppRouter.buyerPlaceRequest,
                    arguments: product,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E5E16),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Place Request',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, String emoji) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
