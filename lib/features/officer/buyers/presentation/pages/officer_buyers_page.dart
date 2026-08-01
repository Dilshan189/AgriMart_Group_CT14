import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/models/user_model.dart';

class OfficerBuyersPage extends ConsumerStatefulWidget {
  const OfficerBuyersPage({super.key});

  @override
  ConsumerState<OfficerBuyersPage> createState() => _OfficerBuyersPageState();
}

class _OfficerBuyersPageState extends ConsumerState<OfficerBuyersPage> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final buyersAsync = ref.watch(buyersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4), // Slightly darker grey to match screenshot
      appBar: AppBar(
        automaticallyImplyLeading: false, // Omit back button since it's a tab
        backgroundColor: const Color(0xFF8D5A36), // Brown background
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Manage Buyers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: buyersAsync.when(
          data: (buyers) {
            int total = buyers.length;
            int activeCount = buyers.where((b) => b.status == 'approved').length;
            int suspendedCount = buyers.where((b) => b.status == 'suspended').length;

            List<UserModel> filteredBuyers = buyers.where((b) {
              bool matchesSearch = b.name.toLowerCase().contains(_searchQuery) ||
                  (b.district ?? '').toLowerCase().contains(_searchQuery);

              bool matchesFilter = true;
              if (_selectedFilter == 'Active') {
                matchesFilter = b.status == 'approved';
              } else if (_selectedFilter == 'Suspended') {
                matchesFilter = b.status == 'suspended';
              }
              return matchesSearch && matchesFilter;
            }).toList();

            UserModel? topBuyer;
            List<UserModel> otherBuyers = [];

            if (filteredBuyers.isNotEmpty) {
              if (_searchQuery.isEmpty && _selectedFilter == 'All') {
                // Mockup logic: first active buyer is marked as Top Buyer for the UI only on 'All' view
                int topIndex = filteredBuyers.indexWhere((b) => b.status == 'approved');
                if (topIndex != -1) {
                  topBuyer = filteredBuyers[topIndex];
                  otherBuyers = List.from(filteredBuyers)..removeAt(topIndex);
                } else {
                  otherBuyers = filteredBuyers;
                }
              } else {
                otherBuyers = filteredBuyers;
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agricultural Officer — Zone 3 Overview',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Stat Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          total.toString(),
                          'Total',
                          const Color(0xFFEBF4FE),
                          const Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          activeCount.toString(),
                          'Active',
                          const Color(0xFFF0F7ED),
                          const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          suspendedCount.toString(),
                          'Suspended',
                          const Color(0xFFFDF0ED),
                          const Color(0xFF8D6E63), // Brownish text like in screenshot
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search buyers...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
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
                        _buildFilterChip('All', total),
                        const SizedBox(width: 8),
                        _buildFilterChip('Active', activeCount),
                        const SizedBox(width: 8),
                        _buildFilterChip('Suspended', suspendedCount),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Top Buyers Section
                  if (topBuyer != null) ...[
                    const Text(
                      'Top Buyers',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBuyerCard(topBuyer, isTopBuyer: true, isSuspended: false),
                    const SizedBox(height: 24),
                  ],

                  // All Buyers Section
                  if (_searchQuery.isEmpty && _selectedFilter == 'All') ...[
                    const Text(
                      'All Buyers',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  if (otherBuyers.isEmpty && topBuyer == null)
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No buyers found.',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  else
                    ...otherBuyers.map((b) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildBuyerCard(b, isTopBuyer: false, isSuspended: b.status == 'suspended'),
                      );
                    }).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildStatCard(String count, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor.withOpacity(0.8), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
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
          color: isSelected ? Colors.orange.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.orange.shade200 : Colors.grey.shade300,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: isSelected ? Colors.brown.shade800 : Colors.grey.shade500,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildBuyerCard(UserModel buyer, {required bool isTopBuyer, required bool isSuspended}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.black54, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buyer.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${buyer.district ?? 'Unknown'} · ${isTopBuyer ? '6' : '0'} orders placed',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSuspended 
                  ? Colors.red.shade50 
                  : (isTopBuyer ? Colors.blue.shade50 : Colors.green.shade50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isSuspended ? 'Suspended' : (isTopBuyer ? 'Top Buyer' : 'Active'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSuspended 
                    ? Colors.red.shade700 
                    : (isTopBuyer ? Colors.blue.shade700 : Colors.green.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
