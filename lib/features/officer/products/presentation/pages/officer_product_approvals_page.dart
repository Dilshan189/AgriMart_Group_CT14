import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/product_provider.dart';
import '../../../../../core/models/product_model.dart';
import 'package:intl/intl.dart';

class OfficerProductApprovalsPage extends ConsumerStatefulWidget {
  const OfficerProductApprovalsPage({super.key});

  @override
  ConsumerState<OfficerProductApprovalsPage> createState() => _OfficerProductApprovalsPageState();
}

class _OfficerProductApprovalsPageState extends ConsumerState<OfficerProductApprovalsPage> {
  String _selectedFilter = 'Pending';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8D5A36), // Brown
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Approvals',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          productsAsync.when(
            data: (products) {
              final pendingCount = products.where((p) => p.status == 'pending').length;
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    '$pendingCount pending',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (err, stack) => const SizedBox(),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          final pendingProducts = products.where((p) => p.status == 'pending').toList();
          final approvedProducts = products.where((p) => p.status == 'active').toList();
          final totalCount = products.length;
          final pendingCount = pendingProducts.length;
          final approvedCount = approvedProducts.length;

          // Filter logic
          List<ProductModel> displayedPending = [];
          List<ProductModel> displayedApproved = [];

          if (_selectedFilter == 'All') {
            displayedPending = pendingProducts;
            displayedApproved = approvedProducts;
          } else if (_selectedFilter == 'Pending') {
            displayedPending = pendingProducts;
          } else if (_selectedFilter == 'Approved') {
            displayedApproved = approvedProducts;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Chips
                Row(
                  children: [
                    _buildFilterChip('All', totalCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('Approved', approvedCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending', pendingCount),
                  ],
                ),
                const SizedBox(height: 20),

                // Farmer submitted (Pending Section)
                if (displayedPending.isNotEmpty) ...[
                  const Text(
                    'Farmer submitted',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  ...displayedPending.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildApprovalCard(p),
                      )),
                ],

                // Recently approved (Approved Section)
                if (displayedApproved.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Recently approved',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  ...displayedApproved.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildRecentlyApprovedCard(p),
                      )),
                ],

                if (displayedPending.isEmpty && displayedApproved.isEmpty)
                  const Center(child: Text('No products found')),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFCC80) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          '$label($count)',
          style: TextStyle(
            color: isSelected ? const Color(0xFF795548) : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalCard(ProductModel product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFC5E1A5),
                  shape: BoxShape.circle,
                  image: product.imageUrl != null && product.imageUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(product.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "🧑‍🌾 ${product.farmerName} · ${product.quantity}${product.unit} · Rs.${product.price}/${product.unit}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "📍 ${product.location} · ${DateFormat('MMM d, h:mm a').format(product.createdAt)}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // View uploaded photo button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                // View photo logic
              },
              icon: const Icon(Icons.image, color: Colors.black87, size: 18),
              label: const Text(
                'View uploaded photo',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE8F5E9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final updated = product.copyWith(status: 'active');
                    ref
                        .read(productControllerProvider.notifier)
                        .updateProduct(updated);
                  },
                  icon: const Icon(Icons.check, color: Colors.white, size: 16),
                  label: const Text(
                    'Approve',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(productControllerProvider.notifier)
                        .deleteProduct(product.id);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFC62828),
                    size: 16,
                  ),
                  label: const Text(
                    'Reject',
                    style: TextStyle(
                      color: Color(0xFFC62828),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFC62828)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyApprovedCard(ProductModel product) {
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
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F8E9),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🧑‍🌾', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  product.farmerName,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  'Approved today · live to buyers',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Approved',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
