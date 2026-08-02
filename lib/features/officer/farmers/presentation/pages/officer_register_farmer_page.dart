import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers/auth_provider.dart';
import 'package:dotted_border/dotted_border.dart';

class OfficerRegisterFarmerPage extends ConsumerStatefulWidget {
  const OfficerRegisterFarmerPage({super.key});

  @override
  ConsumerState<OfficerRegisterFarmerPage> createState() => _OfficerRegisterFarmerPageState();
}

class _OfficerRegisterFarmerPageState extends ConsumerState<OfficerRegisterFarmerPage> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1 Controllers
  final _fullNameController = TextEditingController();
  final _nicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedDistrict = 'Matara';
  String? _selectedZone;

  // Step 2 Controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _printSlip = true;
  bool _isLoading = false;

  final List<String> _districts = [
    'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo', 'Galle',
    'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara', 'Kandy', 'Kegalle',
    'Kilinochchi', 'Kurunegala', 'Mannar', 'Matale', 'Matara', 'Monaragala',
    'Mullaitivu', 'Nuwara Eliya', 'Polonnaruwa', 'Puttalam', 'Ratnapura',
    'Trincomalee', 'Vavuniya'
  ];

  final List<String> _zones = [
    'Zone 1', 'Zone 2', 'Zone 3', 'Zone 4', 'Zone 5'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _nicController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
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
        'contact': _phoneController.text,
        'email': _emailController.text,
        'district': _selectedDistrict ?? '',
        'zone': _selectedZone ?? '',
        'role': 'farmer',
        'status': 'approved', // Assuming officers instantly approve them
      };

      await ref.read(authControllerProvider.notifier).registerWithoutLoggingOut(
        _emailController.text.isNotEmpty ? _emailController.text : '${_phoneController.text}@agrimart.local',
        _passwordController.text,
        userData,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Farmer registered successfully!')),
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
          'Register Farmer',
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
          _buildTopBanner('Registering as: Farmer', '🧑‍🌾', isStep1: true),
          const SizedBox(height: 24),
          const Text(
            'Full Name',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildTextField(controller: _fullNameController, hintText: 'Kumarasinghe K.M.B.S.S'),
          const SizedBox(height: 16),
          
          const Text(
            'NIC Number',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildTextField(controller: _nicController, hintText: 'e.g. 199012345678'),
          const SizedBox(height: 16),
          
          const Text(
            'Phone Number',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildTextField(controller: _phoneController, hintText: 'e.g. 077 123 4567', keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          
          const Text(
            'Email (optional)',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildTextField(controller: _emailController, hintText: 'farmer@email.com', keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 24),
          
          const Text(
            'Farm Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'District',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildDropdownField(
            value: _selectedDistrict,
            items: _districts,
            hint: 'Select district',
            onChanged: (val) => setState(() => _selectedDistrict = val),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Farm GPS Location',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildGpsButton(),
          const SizedBox(height: 16),
          
          const Text(
            'Agricultural Zone',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildDropdownField(
            value: _selectedZone,
            items: _zones,
            hint: 'Select zone',
            onChanged: (val) => setState(() => _selectedZone = val),
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
            '${_fullNameController.text.isNotEmpty ? _fullNameController.text : 'New Farmer'}\n${_selectedDistrict ?? 'Unknown'} - ${_selectedZone ?? 'No Zone'}',
            '🧑‍🌾',
            isStep1: false,
          ),
          const SizedBox(height: 24),
          const Text(
            'Login Credentials',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            'These will be given to the farmer to log in to AgriMart',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          const Text(
            'Username / Phone',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildTextField(controller: _usernameController, hintText: '0771234567'),
          const SizedBox(height: 16),
          
          const Text(
            'Password',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          _buildTextField(controller: _passwordController, hintText: '••••••••', obscureText: true),
          const SizedBox(height: 4),
          Text(
            'Farmer must change this on first login',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Confirm Password',
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 6),
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
                  'After submitting, a credential slip can be printed or shown to the farmer with their login details.',
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
                : const Text('✓ Complete Farmer Registration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTopBanner(String text, String icon, {required bool isStep1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9), // Light green
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC5E1A5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFC5E1A5), // Darker light green
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 20)),
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

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildGpsButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPS Location fetched! (Mock)')),
        );
      },
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: Colors.green,
          strokeWidth: 1,
          dashPattern: const [6, 4],
          radius: const Radius.circular(8),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F8E9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            children: [
              Icon(Icons.location_on, color: Colors.black87, size: 28),
              SizedBox(height: 8),
              Text(
                'Use Current Location',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                'Tap to enable GPS',
                style: TextStyle(color: Colors.green, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
