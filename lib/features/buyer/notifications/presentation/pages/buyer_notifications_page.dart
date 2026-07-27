import 'package:flutter/material.dart';

class BuyerNotificationsPage extends StatelessWidget {
  const BuyerNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationCard(
            title: 'New buyer request',
            subtitle: 'Sandeepa K.H. requested 30kg of Tomatoes',
            time: '2m ago',
            leftBorderColor: const Color(0xFF2E7D32), // Green
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'Product approved',
            subtitle: 'Your Spinach listing was approved by the officer',
            time: '1h ago',
            leftBorderColor: const Color(0xFF1565C0), // Blue
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'New product near you',
            subtitle: 'Organic Rice (200kg) listed in Colombo District',
            time: '3h ago',
            leftBorderColor: const Color(0xFF8D6E63), // Brown
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'Request accepted',
            subtitle: 'Your request for Spinach was accepted by Kumarasinghe',
            time: 'Yesterday',
            leftBorderColor: Colors.grey.shade300, // Light grey
          ),
        ],
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
            // Left color border indicator
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
            // Content
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
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
