import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/product_provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/models/product_model.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final Color primaryGreen = const Color(0xFF387015);
  final Color backgroundGrey = const Color(0xFFF9F9F9);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

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

  void _submitProduct() async {
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

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUserModel();
      if (user == null) {
        throw Exception('User not logged in');
      }

      final product = ProductModel(
        id: '', // Firestore auto-generates this if we use doc().set() in repo
        farmerId: user.id,
        farmerName: user.name,
        name: name,
        category: category,
        quantity: double.tryParse(quantityText) ?? 0,
        unit: 'kg',
        location: location,
        description: description,
        price: double.tryParse(priceText) ?? 0,
        createdAt: DateTime.now(),
        status: 'active', // default status
      );

      await ref.read(productControllerProvider.notifier).addProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
        Navigator.pop(context); // Go back after adding
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
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
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageUploadBox(),
            const SizedBox(height: 16),
            _buildLabel('Product Name *'),
            _buildTextField(controller: _nameController, hintText: 'e.g Organic Tomatoes', prefixIcon: '🌿'),
            const SizedBox(height: 16),
            _buildLabel('Category *'),
            _buildTextField(controller: _categoryController, hintText: 'Vegetables', prefixIcon: '🥦'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Quantity (kg) *'),
                      _buildTextField(controller: _quantityController, hintText: 'e.g. 100', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Price (Rs/kg) *'),
                      _buildTextField(controller: _priceController, hintText: 'e.g. 120', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel('Location (GPS) *'),
            _buildCurrentLocationBox(),
            const SizedBox(height: 8),
            _buildTextField(controller: _locationController, hintText: 'Or enter location manually'),
            const SizedBox(height: 16),
            _buildLabel('Description (optional)'),
            _buildTextField(
              controller: _descriptionController,
              hintText: 'Describe your product...',
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
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
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(prefixIcon, style: const TextStyle(fontSize: 16)),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: maxLines > 1 ? 16 : 12,
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadBox() {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: const Color(0xFF9CCC65),
        strokeWidth: 1.5,
        dashPattern: const [8, 4],
        radius: const Radius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_outlined, color: Colors.black87, size: 32),
            const SizedBox(height: 8),
            const Text(
              'Tap to upload product photo',
              style: TextStyle(
                color: Color(0xFF387015),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'JPG, PNG up to 5MB',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationBox() {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: const Color(0xFF9CCC65),
        strokeWidth: 1.5,
        dashPattern: const [8, 4],
        radius: const Radius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8E9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.black87, size: 24),
            const SizedBox(height: 8),
            const Text(
              'Use Current Location',
              style: TextStyle(
                color: Color(0xFF387015),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to enable GPS',
              style: TextStyle(
                color: Color(0xFF387015),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
