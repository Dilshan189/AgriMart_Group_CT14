import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../../../core/models/user_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final Color primaryGreen = const Color(0xFF387015);
  final Color backgroundGrey = const Color(0xFFF9F9F9);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isGettingLocation = false;
  bool _isLoading = false;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentUser = ref.read(currentUserProvider).value;
      if (_currentUser != null) {
        _nameController.text = _currentUser!.name;
        _phoneController.text = _currentUser!.phone ?? '';
        _nicController.text = _currentUser!.nic ?? '';
        _locationController.text = _currentUser!.district ?? '';
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nicController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

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
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _locationController.text = '${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGettingLocation = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_currentUser == null) return;
    
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final nic = _nicController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || phone.isEmpty || nic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updates = {
        'name': name,
        'phone': phone,
        'nic': nic,
        'district': location,
      };

      await ref.read(userControllerProvider.notifier).updateUserProfile(_currentUser!.id, updates);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Full Name *'),
                  _buildTextField(controller: _nameController, hintText: 'e.g Sandeepa K.H.', prefixIcon: '🧑‍🌾'),
                  const SizedBox(height: 16),
                  _buildLabel('Phone Number *'),
                  _buildTextField(controller: _phoneController, hintText: 'e.g 0712345678', prefixIcon: '📱', keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildLabel('NIC Number *'),
                  _buildTextField(controller: _nicController, hintText: 'e.g 991234567V', prefixIcon: '🪪'),
                  const SizedBox(height: 24),
                  _buildLabel('Farm Location'),
                  const SizedBox(height: 8),
                  _buildCurrentLocationBox(),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(prefixIcon, style: const TextStyle(fontSize: 18)),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
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
            color: const Color(0xFFF1F8E9), 
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
                  'Update Farm Location via GPS',
                  style: TextStyle(
                    color: Color(0xFF387015),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!hasLocation) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Tap to get new coordinates',
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
                      color: const Color(0xFF387015), 
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
