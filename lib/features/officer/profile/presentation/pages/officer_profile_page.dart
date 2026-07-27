import 'package:flutter/material.dart';

class OfficerProfilePage extends StatelessWidget {
  const OfficerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              color: const Color(0xFF8D5A36), // Brown
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Custom AppBar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: const [
                              Text('✏️', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 4),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Profile Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.pink.shade100,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kumarasinghe\nK.M.B.S.S',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Agricultural Officer · Zone 3',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8D5A36),
                                    border: Border.all(color: Colors.white38),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    '⚙️ System Admin',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats Row
                    Container(
                      color: const Color(0xFF5D4037), // Darker brown
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(child: _buildStatItem('24', 'Farmers')),
                          Container(width: 1, height: 30, color: Colors.white38),
                          Expanded(child: _buildStatItem('57', 'Buyers')),
                          Container(width: 1, height: 30, color: Colors.white38),
                          Expanded(child: _buildStatItem('3', 'Zone')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // List Items
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  _buildListTile('👤', 'Officer Info', 'Name, ID, department'),
                  _buildListTile('🗺️', 'Zone Management', 'Zone 3 · Colombo District'),
                  _buildListTile('📊', 'Zone Reports', 'Weekly summaries'),
                  _buildListTile('🔔', 'Notifications', 'System alerts'),
                  _buildListTile('🔒', 'Change Password', 'Security settings'),
                  _buildListTile('ℹ️', 'About AgriMart', 'Security settings'),
                  _buildListTile('🚪', 'Logout', '', isLogout: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(String emoji, String title, String subtitle, {bool isLogout = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.red.shade100, // Pinkish red
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isLogout ? Colors.red.shade800 : Colors.black87,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            )
          : null,
      onTap: () {},
    );
  }
}
