import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/product_provider.dart';
import '../../../../../core/providers/user_provider.dart';

class AppNotificationsPage extends ConsumerWidget {
  const AppNotificationsPage({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final productsAsync = ref.watch(allProductsProvider);
    final farmersAsync = ref.watch(farmersProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User not found. Please log in.')),
          );
        }

        final role = user.role;
        Color themeColor = const Color(0xFF387015); // Farmer (Green)
        if (role == 'buyer') {
          themeColor = const Color(0xFF1976D2); // Buyer (Blue)
        } else if (role == 'officer') {
          themeColor = const Color(0xFF8D5A36); // Officer (Brown)
        }

        // Generate dynamic notifications based on user role
        final List<Widget> notificationCards = [];

        if (role == 'officer') {
          final pendingProducts = productsAsync.value?.where((p) => p.status == 'pending').toList() ?? [];
          final pendingFarmers = farmersAsync.value?.where((f) => f.status == 'pending').toList() ?? [];

          for (var p in pendingProducts) {
            notificationCards.add(
              _buildNotificationCard(
                title: 'Pending Product Approval',
                subtitle: '${p.farmerName} submitted a listing: ${p.name} (${p.quantity}${p.unit})',
                time: 'Recently',
                leftBorderColor: Colors.orange,
              ),
            );
          }

          for (var f in pendingFarmers) {
            notificationCards.add(
              _buildNotificationCard(
                title: 'New Farmer Verification Needed',
                subtitle: 'Farmer ${f.name} registered and is pending verification',
                time: 'Recently',
                leftBorderColor: Colors.blue,
              ),
            );
          }

          if (notificationCards.isEmpty) {
            notificationCards.add(
              _buildNotificationCard(
                title: 'System Alert',
                subtitle: 'All products and farmers are currently verified and active.',
                time: 'Today',
                leftBorderColor: Colors.green,
              ),
            );
          }
        } else if (role == 'farmer') {
          final approvedProducts = productsAsync.value?.where((p) => p.farmerId == user.id && p.status == 'active').toList() ?? [];

          for (var p in approvedProducts) {
            notificationCards.add(
              _buildNotificationCard(
                title: 'Listing Approved',
                subtitle: 'Your product listing "${p.name}" has been approved by the officer and is now live to buyers!',
                time: 'Today',
                leftBorderColor: Colors.green,
              ),
            );
          }

          notificationCards.add(
            _buildNotificationCard(
              title: 'Welcome to AgriMart',
              subtitle: 'Start listing your fresh produce to reach nearby buyers!',
              time: 'Registration',
              leftBorderColor: Colors.blue,
            ),
          );
        } else { // Buyer
          final activeProducts = productsAsync.value?.where((p) => p.status == 'active').toList() ?? [];

          for (var p in activeProducts.take(3)) {
            notificationCards.add(
              _buildNotificationCard(
                title: 'New Product Available',
                subtitle: '${p.farmerName} listed ${p.name} in ${p.location} for Rs. ${p.price}/${p.unit}',
                time: 'Recently',
                leftBorderColor: const Color(0xFF8D5A36), // Brown
              ),
            );
          }

          notificationCards.add(
            _buildNotificationCard(
              title: 'Browse Fresh Produce',
              subtitle: 'Find organic fruits and vegetables from farmers near your district.',
              time: 'Welcome',
              leftBorderColor: Colors.blue,
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: themeColor,
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
              'Notifications',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: notificationCards.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => notificationCards[index],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String time,
    required Color leftBorderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: leftBorderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
