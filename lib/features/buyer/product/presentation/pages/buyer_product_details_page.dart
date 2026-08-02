import 'package:agri_mart/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/providers/user_provider.dart';

class BuyerProductDetailsPage extends ConsumerWidget {
  final ProductModel product;

  const BuyerProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAvailable = product.status == 'active';
    final farmersList = ref.watch(farmersProvider).value ?? [];
    final farmer = farmersList.where((f) => f.id == product.farmerId).firstOrNull;
    bool isVerified = farmer?.status == 'approved';
    
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
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final currentUser = ref.watch(currentUserProvider).value;
              if (currentUser == null) return const SizedBox.shrink();

              final isSaved = currentUser.savedProducts.contains(product.id);

              return IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? Colors.red : Colors.grey.shade700,
                    size: 18,
                  ),
                ),
                onPressed: () {
                  ref.read(userControllerProvider.notifier).toggleSavedProduct(currentUser, product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isSaved ? 'Removed from saved products' : 'Added to saved products')),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Placeholder
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), // Light green background matching screenshot
                borderRadius: BorderRadius.circular(16),
                image: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(product.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Title and Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
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
                      fontWeight: FontWeight.w500,
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
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2E5E16),
              ),
            ),
            const SizedBox(height: 24),

            // Product Details Grid (2x2)
            Row(
              children: [
                Expanded(child: _buildGridItem('Category', product.category, '🥦')),
                const SizedBox(width: 12),
                Expanded(child: _buildGridItem('Available', '${product.quantity} ${product.unit}', '')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildGridItem('Location', product.location.split(',').first, '📍')),
                const SizedBox(width: 12),
                Expanded(child: _buildGridItem('Posted', 'Today', '')),
              ],
            ),
            const SizedBox(height: 24),

            // Farmer Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC5E1A5),
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isVerified ? 'Verified Farmer · ${product.location.split(',').first} District' : 'Farmer · ${product.location.split(',').first} District',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isVerified ? const Color(0xFFEDF5E1) : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isVerified ? Colors.transparent : Colors.orange.shade200,
                      ),
                    ),
                    child: Text(
                      isVerified ? 'Verified' : 'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isVerified ? const Color(0xFF2E5E16) : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Location Box
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: const Color(0xFF9CCC65),
                strokeWidth: 1.5,
                dashPattern: const [6, 4],
                radius: const Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.location_on, color: Colors.black87, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      '${product.location.split(',').first} District, Sri Lanka',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description.isNotEmpty ? product.description : 'No description provided.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.call_outlined, size: 20),
                      label: const Text(
                        'Contact',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2E5E16),
                        side: const BorderSide(color: Color(0xFF2E5E16), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context, 
                          AppRouter.buyerPlaceRequest,
                          arguments: product,
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                      label: const Text(
                        'Request to Buy',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E5E16),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, String value, String iconText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (iconText.isNotEmpty) ...[
                Text(
                  iconText == '📍' ? '' : iconText, 
                  style: const TextStyle(fontSize: 14)
                ),
                if (iconText == '📍')
                  const Icon(Icons.location_on, size: 14, color: Colors.black87),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
