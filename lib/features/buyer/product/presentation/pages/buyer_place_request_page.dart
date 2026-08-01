import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/models/request_model.dart';
import '../../../../../core/providers/request_provider.dart';
import '../../../../../core/providers/auth_provider.dart';

class BuyerPlaceRequestPage extends ConsumerStatefulWidget {
  final ProductModel product;

  const BuyerPlaceRequestPage({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<BuyerPlaceRequestPage> createState() => _BuyerPlaceRequestPageState();
}

class _BuyerPlaceRequestPageState extends ConsumerState<BuyerPlaceRequestPage> {
  late double _quantity;
  late double _maxQuantity;
  late double _unitPrice;
  bool _isPickup = true; // true for pickup, false for delivery
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _maxQuantity = widget.product.quantity;
    _quantity = _maxQuantity > 0 ? (_maxQuantity >= 10 ? 10 : 1) : 0;
    _unitPrice = widget.product.price;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    if (_quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid quantity')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUserModel();
      if (user == null) throw Exception('User not logged in');

      final request = RequestModel(
        id: '',
        productId: widget.product.id,
        productName: widget.product.name,
        buyerId: user.id,
        buyerName: user.name,
        farmerId: widget.product.farmerId,
        farmerName: widget.product.farmerName,
        quantity: _quantity,
        totalPrice: _quantity * _unitPrice,
        status: 'pending',
        deliveryType: _isPickup ? 'pickup' : 'delivery',
        note: _noteController.text.trim(),
        createdAt: DateTime.now(),
      );

      await ref.read(requestControllerProvider.notifier).submitRequest(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request placed successfully!')),
        );
        Navigator.pop(context); // Go back to product details
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Place Request',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8E9), 
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA5D6A7), width: 1), 
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEED9),
                      borderRadius: BorderRadius.circular(12),
                      image: widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(widget.product.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.product.imageUrl == null || widget.product.imageUrl!.isEmpty
                        ? const Icon(Icons.image, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDF5E1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFC5E1A5)),
                              ),
                              child: const Text(
                                'Available',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs. ${widget.product.price}/${widget.product.unit} · Max\n${widget.product.quantity}${widget.product.unit} available',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quantity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Required Quantity (${widget.product.unit})',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  'Max: $_maxQuantity ${widget.product.unit}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if (_quantity > 1) {
                        setState(() => _quantity--);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: const Text('-', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: Text(
                      _quantity.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_quantity < _maxQuantity) {
                        setState(() => _quantity++);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: const Text('+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Estimated Total Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Unit price', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      Text('Rs. $_unitPrice / ${widget.product.unit}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      Text('$_quantity ${widget.product.unit}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Estimated Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        'Rs. ${(_unitPrice * _quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery Preference
            Text(
              'Delivery / Pickup Preference',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isPickup = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _isPickup ? const Color(0xFFF1F8E9) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isPickup ? const Color(0xFF2E7D32) : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text('🏠', style: TextStyle(fontSize: 24)),
                          const SizedBox(height: 8),
                          Text(
                            'Pickup from farm',
                            style: TextStyle(
                              fontSize: 11,
                              color: _isPickup ? const Color(0xFF2E7D32) : Colors.grey.shade600,
                              fontWeight: _isPickup ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isPickup = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: !_isPickup ? const Color(0xFFF1F8E9) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: !_isPickup ? const Color(0xFF2E7D32) : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text('🚚', style: TextStyle(fontSize: 24)),
                          const SizedBox(height: 8),
                          Text(
                            'Request delivery',
                            style: TextStyle(
                              fontSize: 11,
                              color: !_isPickup ? const Color(0xFF2E7D32) : Colors.grey.shade600,
                              fontWeight: !_isPickup ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Note to Farmer
            Text(
              'Note to Farmer (optional)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Any special requirements...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitRequest,
                icon: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.check, color: Colors.white, size: 20),
                label: Text(
                  _isLoading ? 'Submitting...' : 'Submit Request',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF387015),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
