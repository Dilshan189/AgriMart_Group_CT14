import 'package:flutter/material.dart';

class BuyerProfilePage extends StatelessWidget {
  const BuyerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header Section (Blue Background)
            Container(
              color: const Color(0xFF1976D2), // Standard Blue
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.edit, color: Colors.orangeAccent, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // User Info Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.black54,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Text Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kumarasinghe\nK.M.B.S.S',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Buyer - Colombo District',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Badge Button
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withOpacity(0.4)),
                              ),
                              child: const Text(
                                '4 Orders placed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            
            // Stats Row (Dark Blue Background)
            Container(
              color: const Color(0xFF153448), // Dark Blue Navy
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('4', 'Orders'),
                  _buildDivider(),
                  _buildStatItem('3', 'Accepted'),
                  _buildDivider(),
                  _buildStatItem('2', 'Saved'),
                ],
              ),
            ),
            
            // Menu List
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Info',
                    subtitle: 'Name, phone, email',
                  ),
                  _buildListDivider(),
                  _buildMenuItem(
                    icon: Icons.add_circle_outline,
                    title: 'Post a Request',
                    subtitle: 'Request a product from farmers',
                    iconColor: Colors.green,
                    bgColor: Colors.green.shade50,
                    onTap: () {
                      Navigator.pushNamed(context, '/buyerPostOpenRequest');
                    },
                  ),
                  _buildListDivider(),
                  _buildMenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'My Orders',
                    subtitle: '4 orders placed',
                  ),
                  _buildListDivider(),
                  _buildMenuItem(
                    icon: Icons.favorite_border,
                    title: 'Saved Products',
                    subtitle: '2 saved items',
                  ),
                  _buildListDivider(),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Address',
                    subtitle: 'Colombo 07',
                  ),
                  _buildListDivider(),
                  _buildMenuItem(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    subtitle: 'Manage alerts',
                    iconColor: Colors.orange,
                    bgColor: Colors.orange.withOpacity(0.1),
                  ),
                  _buildListDivider(),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Security settings',
                    iconColor: Colors.amber,
                    bgColor: Colors.amber.withOpacity(0.1),
                  ),
                  _buildListDivider(),
                  _buildMenuItem(
                    icon: Icons.exit_to_app,
                    title: 'Logout',
                    subtitle: '',
                    iconColor: Colors.red,
                    bgColor: Colors.red.withOpacity(0.1),
                    titleColor: Colors.red,
                    isLogout: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildListDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70, right: 20),
      child: Divider(color: Colors.grey.shade200, height: 1),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    Color? bgColor,
    Color? titleColor,
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    final effectiveIconColor = iconColor ?? Colors.blue.shade700;
    final effectiveBgColor = bgColor ?? Colors.blue.shade50;
    final effectiveTitleColor = titleColor ?? Colors.black87;

    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: effectiveBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: effectiveIconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: effectiveTitleColor,
                    ),
                  ),
                  if (!isLogout) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
