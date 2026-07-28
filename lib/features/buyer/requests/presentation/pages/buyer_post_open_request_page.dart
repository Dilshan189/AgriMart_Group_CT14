import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../core/providers/open_request_provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/models/open_request_model.dart';

class BuyerPostOpenRequestPage extends ConsumerStatefulWidget {
  const BuyerPostOpenRequestPage({super.key});

  @override
  ConsumerState<BuyerPostOpenRequestPage> createState() => _BuyerPostOpenRequestPageState();
}

class _BuyerPostOpenRequestPageState extends ConsumerState<BuyerPostOpenRequestPage> {
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color backgroundGrey = const Color(0xFFF9F9F9);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location denied');
      }
      
      if (permission == LocationPermission.deniedForever) throw Exception('Location permanently denied');

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _locationController.text = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    } finally {
      if (mounted) setState(() { _isGettingLocation = false; });
    }
  }

  void _submitRequest() async {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final quantityText = _quantityController.text.trim();
    final priceText = _priceController.text.trim();
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || category.isEmpty || quantityText.isEmpty || priceText.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUserModel();
      if (user == null) throw Exception('User not logged in');

      final request = OpenRequestModel(
        id: '', 
        buyerId: user.id,
        buyerName: user.name,
        productName: name,
        category: category,
        quantity: double.tryParse(quantityText) ?? 0,
        expectedPrice: double.tryParse(priceText) ?? 0,
        location: location,
        description: description,
        createdAt: DateTime.now(),
        status: 'active',
      );

      await ref.read(openRequestControllerProvider.notifier).submitRequest(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request posted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Post an Open Request',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('What do you need? *'),
            _buildTextField(controller: _nameController, hintText: 'e.g 100kg of Rice', prefixIcon: '🌾'),
            const SizedBox(height: 16),
            _buildLabel('Category *'),
            _buildTextField(controller: _categoryController, hintText: 'Grains', prefixIcon: '📦'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Quantity (kg) *'),
                      _buildTextField(controller: _quantityController, hintText: '100', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Expected Price (Rs/kg) *'),
                      _buildTextField(controller: _priceController, hintText: '120', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel('Delivery Location *'),
            Row(
              children: [
                Expanded(child: _buildTextField(controller: _locationController, hintText: 'Enter location')),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isGettingLocation ? null : _getCurrentLocation,
                  icon: _isGettingLocation 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.my_location, color: primaryBlue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel('More Details (optional)'),
            _buildTextField(controller: _descriptionController, hintText: 'Any specific requirements?', maxLines: 4),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Post Request', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    String? hintText, 
    String? prefixIcon, 
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: prefixIcon != null
              ? Padding(padding: const EdgeInsets.all(12.0), child: Text(prefixIcon, style: const TextStyle(fontSize: 16)))
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 16 : 12),
        ),
      ),
    );
  }
}
