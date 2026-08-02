import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../../core/providers/product_provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/models/product_model.dart';

class AddProductPage extends ConsumerStatefulWidget {
  final ProductModel? productToEdit;
  
  const AddProductPage({super.key, this.productToEdit});

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

  File? _selectedImage;
  bool _isExistingImageRemoved = false;
  bool _isLoading = false;
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;
      _nameController.text = p.name;
      _categoryController.text = p.category;
      _quantityController.text = p.quantity.toString();
      _priceController.text = p.price.toString();
      _locationController.text = p.location;
      _descriptionController.text = p.description;
    }
  }

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _isExistingImageRemoved = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      } 

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _locationController.text = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
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

      String? finalImageUrl = widget.productToEdit?.imageUrl;
      
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        
        final uploadTask = await storageRef.putFile(_selectedImage!);
        finalImageUrl = await uploadTask.ref.getDownloadURL();
      } else if (_isExistingImageRemoved) {
        finalImageUrl = ''; // Explicitly removed
      } else {
        finalImageUrl = widget.productToEdit?.imageUrl; // Keep existing
      }

      final product = ProductModel(
        id: widget.productToEdit?.id ?? '', // Firestore auto-generates this if we use doc().set() in repo
        farmerId: user.id,
        farmerName: user.name,
        name: name,
        category: category,
        quantity: double.tryParse(quantityText) ?? 0,
        unit: 'kg',
        location: location,
        description: description,
        price: double.tryParse(priceText) ?? 0,
        createdAt: widget.productToEdit?.createdAt ?? DateTime.now(),
        status: widget.productToEdit?.status ?? 'pending',
        imageUrl: finalImageUrl,
      );

      if (widget.productToEdit != null) {
        await ref.read(productControllerProvider.notifier).updateProduct(product);
      } else {
        await ref.read(productControllerProvider.notifier).addProduct(product);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.productToEdit != null ? 'Product updated successfully!' : 'Product added successfully!')),
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
        title: Text(
          widget.productToEdit != null ? 'Edit Product' : 'Add Product',
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
                    : Text(
                        widget.productToEdit != null ? 'Save Changes' : 'Submit Product',
                        style: const TextStyle(
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
    bool hasExistingImage = widget.productToEdit?.imageUrl != null && widget.productToEdit!.imageUrl!.isNotEmpty && !_isExistingImageRemoved;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _selectedImage == null && !hasExistingImage ? _pickImage : null,
          child: _selectedImage != null || hasExistingImage
              ? Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8E9), // Light green background
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF9CCC65), width: 1.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _selectedImage != null
                            ? Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              )
                            : Image.network(
                                widget.productToEdit!.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = null;
                            _isExistingImageRemoved = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD32F2F), // Red background
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ],
                )
              : DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: const Color(0xFF9CCC65),
                    strokeWidth: 1.5,
                    dashPattern: const [8, 4],
                    radius: const Radius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9), // Matches screenshot light green background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⏳', style: TextStyle(fontSize: 32)),
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
                ),
        ),
        if (_selectedImage != null || hasExistingImage) ...[
          const SizedBox(height: 8),
          const Text(
            'Photo selected',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildCurrentLocationBox() {
    bool hasLocation = _locationController.text.isNotEmpty;
    
    return GestureDetector(
      onTap: _isGettingLocation ? null : _getCurrentLocation,
      child: DottedBorder(
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
            color: const Color(0xFFF1F8E9), // Light green background matching screenshot
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isGettingLocation)
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF387015)),
                )
              else ...[
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
                if (!hasLocation) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Tap to enable GPS',
                    style: TextStyle(
                      color: Color(0xFF387015),
                      fontSize: 10,
                    ),
                  ),
                ],
                if (hasLocation) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF387015), // Solid green button
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '✓ Location detected',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]
              ],
            ],
          ),
        ),
      ),
    );
  }
}
