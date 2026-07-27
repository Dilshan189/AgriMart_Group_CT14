import 'package:flutter/material.dart';

class OfficerDashboardContent extends StatelessWidget {
  const OfficerDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Text(
            'Agricultural Officer — Zone 3 Overview',
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
                  '24',
                  'Farmers',
                  bgColor: const Color(0xFFEDF5E1),
                  borderColor: const Color(0xFFC5E1A5),
                  textColor: const Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  '57',
                  'Buyers',
                  bgColor: Colors.blue.shade50,
                  borderColor: Colors.blue.shade200,
                  textColor: Colors.blue.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  '143',
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
                  '24',
                  'Farmers',
                  bgColor: Colors.white,
                  borderColor: Colors.red.shade100,
                  textColor: const Color(0xFF1B5E20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '57',
                  'Buyers',
                  bgColor: Colors.white,
                  borderColor: Colors.red.shade100,
                  textColor: const Color(0xFF1B5E20),
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
                _buildActivityItem(
                  '🆕',
                  'New farmer registration: ',
                  'Wickramasinghe W.',
                ),
                const SizedBox(height: 12),
                _buildActivityItem(
                  '📦',
                  'New product listed: ',
                  'Organic Rice — 200kg',
                ),
                const SizedBox(height: 12),
                _buildActivityItem(
                  '⚠️',
                  'Flagged listing requires review',
                  '',
                  isAlert: true,
                ),
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
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String emoji, String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Color(0xFF8D6E63), width: 1), // Brown border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D4C41), // Dark brown text
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
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: isAlert ? Colors.red.shade400 : Colors.black87,
              ),
              children: [
                TextSpan(
                  text: title,
                ),
                if (subtitle.isNotEmpty)
                  TextSpan(
                    text: subtitle,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
