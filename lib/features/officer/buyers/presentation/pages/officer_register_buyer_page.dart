import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/auth_provider.dart';

class OfficerRegisterBuyerPage extends ConsumerStatefulWidget {
  const OfficerRegisterBuyerPage({super.key});

  @override
  ConsumerState<OfficerRegisterBuyerPage> createState() => _OfficerRegisterBuyerPageState();
}

class _OfficerRegisterBuyerPageState extends ConsumerState<OfficerRegisterBuyerPage> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1 Controllers
  final _fullNameController = TextEditingController();
  final _nicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _districtController = TextEditingController();
  final _addressController = TextEditingController();
  String _buyerType = 'Individual';

  // Step 2 Controllers
  final _usernameController = TextEditingController(); // Same as phone usually
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _printSlip = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _nicController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // Sync phone to username for step 2
    _usernameController.text = _phoneController.text;
    
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentStep = 1;
    });
  }

  void _prevStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentStep = 0;
    });
  }

  Future<void> _submitRegistration() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userData = {
        'name': _fullNameController.text,
        'nic': _nicController.text,
        'contact': _phoneController.text, // phone number mapping
        'email': _emailController.text,
        'district': _districtController.text,
        'address': _addressController.text,
        'buyerType': _buyerType,
        'role': 'buyer',
        'status': 'approved',
      };

      await ref.read(authControllerProvider.notifier).registerWithoutLoggingOut(
        _emailController.text.isNotEmpty ? _emailController.text : '${_phoneController.text}@agrimart.local',
        _passwordController.text,
        userData,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buyer registered successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
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
        backgroundColor: const Color(0xFF8D5A36), // Brown
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 16),
          ),
          onPressed: _currentStep == 0 ? () => Navigator.pop(context) : _prevStep,
        ),
        title: const Text(
          'Register Buyer',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStep1(),
          _buildStep2(),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBanner('Registering as: Buyer', isStep1: true),
          const SizedBox(height: 24),
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          _buildLabel('Full Name'),
          _buildTextField(controller: _fullNameController, hintText: 'Perera S.M.'),
          _buildLabel('NIC Number'),
          _buildTextField(controller: _nicController, hintText: 'e.g. 198812345678'),
          _buildLabel('Phone Number'),
          _buildTextField(controller: _phoneController, hintText: 'e.g. 071 234 5678', keyboardType: TextInputType.phone),
          _buildLabel('Email (optional)'),
          _buildTextField(controller: _emailController, hintText: '', keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          const Text(
            'Buyer Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          _buildLabel('District'),
          _buildTextField(controller: _districtController, hintText: 'Matara'),
          _buildLabel('Delivery Address'),
          _buildTextField(controller: _addressController, hintText: 'e.g. No.45, Galle Road, Colombo 07'),
          _buildLabel('Buyer type'),
          Row(
            children: [
              Expanded(
                child: _buildBuyerTypeToggle('Individual', '🧑‍🌾'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBuyerTypeToggle('Business', '🏢'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D5A36),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Next → Credentials', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBanner(
            '${_fullNameController.text.isNotEmpty ? _fullNameController.text : 'New Buyer'}\n${_districtController.text.isNotEmpty ? _districtController.text : 'Unknown District'}',
            isStep1: false,
          ),
          const SizedBox(height: 24),
          const Text(
            'Login Credentials',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            'These will be given to the buyer to log in to AgriMart',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          _buildLabel('Username / Phone'),
          _buildTextField(controller: _usernameController, hintText: '0771234567'),
          _buildLabel('Password'),
          _buildTextField(controller: _passwordController, hintText: '••••••••', obscureText: true),
          const SizedBox(height: 4),
          Text(
            'Buyer must change this on first login',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          _buildLabel('Confirm Password'),
          _buildTextField(controller: _confirmPasswordController, hintText: 'Repeat password', obscureText: true),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _printSlip,
                        onChanged: (val) {
                          setState(() {
                            _printSlip = val ?? true;
                          });
                        },
                        activeColor: const Color(0xFF8D5A36),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Print credential slip',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8D5A36)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'After submitting, a credential slip can be printed or shown to the buyer with their login details.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8D5A36), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D5A36),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('✓ Complete Buyer Registration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTopBanner(String text, {required bool isStep1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isStep1 ? 14 : 12,
                color: Colors.black54,
                fontWeight: isStep1 ? FontWeight.normal : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildBuyerTypeToggle(String label, String icon) {
    bool isSelected = _buyerType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _buyerType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue.shade200 : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
