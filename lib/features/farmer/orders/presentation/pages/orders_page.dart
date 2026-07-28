import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/providers/request_provider.dart';
import '../../../../../core/models/request_model.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  static const Color _green = Color(0xFF387015);
  int _filterIndex = 0;

  final List<String> _filterLabels = [
    'ALL',
    'New',
    'Accepted',
    'Rejected',
  ];

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(farmerRequestsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: requestsAsync.when(
        data: (allRequests) {
          // Sort by newest first
          final sortedRequests = List<RequestModel>.from(allRequests)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          List<RequestModel> filteredRequests;
          if (_filterIndex == 1) {
            filteredRequests = sortedRequests.where((r) => r.status == 'pending').toList();
          } else if (_filterIndex == 2) {
            filteredRequests = sortedRequests.where((r) => r.status == 'accepted').toList();
          } else if (_filterIndex == 3) {
            filteredRequests = sortedRequests.where((r) => r.status == 'rejected').toList();
          } else {
            filteredRequests = sortedRequests;
          }

          int pendingCount = sortedRequests.where((r) => r.status == 'pending').length;
          int acceptedCount = sortedRequests.where((r) => r.status == 'accepted').length;
          int rejectedCount = sortedRequests.where((r) => r.status == 'rejected').length;
          
          final labels = [
            'ALL (${sortedRequests.length})',
            'New ($pendingCount)',
            'Accepted ($acceptedCount)',
            'Rejected ($rejectedCount)',
          ];

          return Column(
            children: [
              _buildFilterTabs(labels),
              if (filteredRequests.isEmpty)
                const Expanded(
                  child: Center(child: Text('No requests found.')),
                )
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: filteredRequests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) => _buildOrderCard(filteredRequests[i]),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _green,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text(
        'Buyer Requests',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Text('🔔', style: TextStyle(fontSize: 20)),
            ),
            Positioned(
              right: 8,
              top: 10,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterTabs(List<String> labels) {
    return Container(
      color: Colors.transparent,
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        children: List.generate(4, (i) {
          final active = _filterIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _filterIndex = i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? const Color(0xFFE8F5E9) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: active ? _green : Colors.grey.shade400,
                  width: active ? 1.5 : 1,
                ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  color: active ? _green : Colors.grey.shade600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(RequestModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        children: [
                          const TextSpan(text: 'Request: '),
                          TextSpan(
                            text: order.productName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Buyer: ${order.buyerName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Quantity: ${order.quantity}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Requested: ${DateFormat('MMM d, yyyy').format(order.createdAt)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          if (order.status == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _updateOrderStatus(order, 'accepted');
                    },
                    icon: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Accept',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _updateOrderStatus(order, 'rejected');
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Reject',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  void _updateOrderStatus(RequestModel request, String newStatus) async {
    try {
      await ref.read(requestControllerProvider.notifier).updateRequestStatus(request.id, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case 'pending':
        bg = Colors.blue.shade50;
        text = Colors.blue.shade700;
        label = 'New Request';
        break;
      case 'accepted':
        bg = const Color(0xFFEDF5E1);
        text = _green;
        label = 'Accepted';
        break;
      case 'rejected':
        bg = Colors.red.shade50;
        text = Colors.red.shade700;
        label = 'Rejected';
        break;
      default:
        bg = Colors.grey.shade100;
        text = Colors.grey.shade600;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
