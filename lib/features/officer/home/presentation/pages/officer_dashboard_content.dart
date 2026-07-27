import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/providers/product_provider.dart';

class OfficerDashboardContent extends ConsumerWidget {
  const OfficerDashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmersAsync = ref.watch(farmersProvider);
    final buyersAsync = ref.watch(buyersProvider);
    final productsAsync = ref.watch(allProductsProvider);

    int farmersCount = farmersAsync.value?.length ?? 0;
    int buyersCount = buyersAsync.value?.length ?? 0;
    int productsCount = productsAsync.value?.length ?? 0;
    
    int flaggedProducts = productsAsync.value?.where((p) => p.status == 'flagged').length ?? 0;
    int pendingProducts = productsAsync.value?.where((p) => p.status == 'pending').length ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Text(
            'Agricultural Officer — Dashboard Overview',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),

          // Top Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '$farmersCount',
                  'Farmers',
                  bgColor: const Color(0xFFEDF5E1),
                  borderColor: const Color(0xFFC5E1A5),
                  textColor: const Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  '$buyersCount',
                  'Buyers',
                  bgColor: Colors.blue.shade50,
                  borderColor: Colors.blue.shade200,
                  textColor: Colors.blue.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  '$productsCount',
                  'Products',
                  bgColor: Colors.orange.shade50,
                  borderColor: Colors.orange.shade200,
                  textColor: Colors.brown.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Second Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '$pendingProducts',
                  'Pending Approval',
                  bgColor: Colors.white,
                  borderColor: Colors.orange.shade100,
                  textColor: Colors.orange.shade800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '$flaggedProducts',
                  'Flagged Items',
                  bgColor: Colors.white,
                  borderColor: Colors.red.shade100,
                  textColor: Colors.red.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildActionButton('🧑‍🌾', 'Manage Farmers')),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton('🛒', 'Manage Buyers')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildActionButton('📦', 'Manage Products')),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton('🔔', 'View Alerts')),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activity
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                if (farmersCount > 0)
                  _buildActivityItem(
                    '🆕',
                    'New farmer registration: ',
                    farmersAsync.value!.last.name,
                  ),
                if (farmersCount > 0) const SizedBox(height: 12),
                if (productsCount > 0)
                  _buildActivityItem(
                    '📦',
                    'New product listed: ',
                    productsAsync.value!.last.name,
                  ),
                if (productsCount > 0) const SizedBox(height: 12),
                if (flaggedProducts > 0)
                  _buildActivityItem(
                    '⚠️',
                    'Flagged listing requires review',
                    '',
                    isAlert: true,
                  ),
                if (farmersCount == 0 && productsCount == 0 && flaggedProducts == 0)
                  const Text('No recent activity.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String emoji, String title, String subtitle, {bool isAlert = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isAlert ? Colors.red.shade50 : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isAlert ? FontWeight.w600 : FontWeight.normal,
                  color: isAlert ? Colors.red.shade700 : Colors.black87,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
