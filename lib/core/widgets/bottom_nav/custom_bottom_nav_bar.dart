import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final String userRole;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.userRole,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> navItems = [];

    if (userRole == 'buyer') {
      navItems = [
        _buildNavItem(context, 0, '🏠', 'Home', isActive: selectedIndex == 0),
        _buildNavItem(context, 1, '🛍️', 'Browse', isActive: selectedIndex == 1),
        _buildNavItem(context, 2, '🔔', 'Alert', isActive: selectedIndex == 2),
        _buildNavItem(context, 3, '📋', 'My Orders', isActive: selectedIndex == 3),
        _buildNavItem(context, 4, '👤', 'Profile', isActive: selectedIndex == 4),
      ];
    } else if (userRole == 'officer') {
      navItems = [
        _buildNavItem(context, 0, '🏡', 'Dashboard', isActive: selectedIndex == 0),
        _buildNavItem(context, 1, '🧑‍🌾', 'Farmers', isActive: selectedIndex == 1),
        _buildNavItem(context, 2, '📦', 'Products', isActive: selectedIndex == 2),
        _buildNavItem(context, 3, '🛒', 'Buyers', isActive: selectedIndex == 3),
        _buildNavItem(context, 4, '👤', 'Profile', isActive: selectedIndex == 4),
      ];
    } else { // farmer
      navItems = [
        _buildNavItem(context, 0, '🏠', 'Home', isActive: selectedIndex == 0),
        _buildNavItem(context, 1, '📦', 'Product', isActive: selectedIndex == 1),
        _buildNavItem(context, 2, '➕', 'add', isCenterIcon: true),
        _buildNavItem(context, 3, '📋', 'Orders', isActive: selectedIndex == 3),
        _buildNavItem(context, 4, '👤', 'Profile', isActive: selectedIndex == 4),
      ];
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String emoji,
    String label, {
    bool isActive = false,
    bool isCenterIcon = false,
  }) {
    final color = isActive ? const Color(0xFF387015) : Colors.grey.shade500;

    return GestureDetector(
      onTap: () {
        if (userRole == 'farmer' && index == 2) {
          // If Farmer and index is 2 (Add product)
          Navigator.pushNamed(context, '/addProduct');
        } else {
          onItemSelected(index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: isCenterIcon ? 28 : 24)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
