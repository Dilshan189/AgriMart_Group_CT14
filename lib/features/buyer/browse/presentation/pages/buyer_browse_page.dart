import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/product_provider.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/router/app_router.dart';

class BuyerBrowsePage extends ConsumerStatefulWidget {
  const BuyerBrowsePage({super.key});

  @override
  ConsumerState<BuyerBrowsePage> createState() => _BuyerBrowsePageState();
}

class _BuyerBrowsePageState extends ConsumerState<BuyerBrowsePage> {
  String _searchQuery = '';
  String _selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'All Products',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.toLowerCase();
                      });
                    },
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
                      _buildFilterChip('ALL'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Fruits'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Vegetables'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Grains'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          
          Expanded(
            child: productsAsync.when(
              data: (products) {
                // Filter by active products only, then by search and category
                final filtered = products.where((p) {
                  if (p.status != 'active') return false;
                  
                  bool matchesSearch = p.name.toLowerCase().contains(_searchQuery) ||
                      p.farmerName.toLowerCase().contains(_searchQuery) ||
                      p.location.toLowerCase().contains(_searchQuery);
                      
                  bool matchesCategory = _selectedCategory == 'ALL' || 
                      p.category.toLowerCase().contains(_selectedCategory.toLowerCase());
                      
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No products available.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Showing ${filtered.length} products near you',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        ),
                      );
                    }
                    return _buildProductCard(filtered[index - 1]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final detailsStr = '${product.quantity} ${product.unit} · Rs.${product.price}/${product.unit} · ${product.location}';
    
    // Determine stock status based on quantity (just an example logic)
    bool isLowStock = product.quantity < 20;
    String status = isLowStock ? 'Low Stock' : 'In Stock';
    Color statusColor = isLowStock ? const Color(0xFFFFF3E0) : const Color(0xFFEDF5E1);
    Color statusTextColor = isLowStock ? const Color(0xFFE65100) : const Color(0xFF2E7D32);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context, 
          AppRouter.buyerProductDetails, 
          arguments: product,
        );
      },
      child: Container(
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
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(left: 8),
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
                    detailsStr,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '🧑‍🌾 ${product.farmerName}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
