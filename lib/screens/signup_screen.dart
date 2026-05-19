// ============================================================
// SIGNUP SCREEN
// New user creates an account
// ============================================================

import 'package:flutter/material.dart';
import 'package:fresh_choice/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'signup_screen.dart'; // fix

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }
    if (!email.contains('@')) {
      _showError('Please enter a valid email');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (!_agreedToTerms) {
      _showError('Please agree to the terms');
      return;
    }

    //  Send to Python backend later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account created! Welcome, $name 🌿'),
        backgroundColor: AppColors.primary,
      ),
    );

    
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGreen),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // LOGO 
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.eco,
                    size: 38,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'Create Account',
                  style: GoogleFonts.anton(
                    fontSize: 30,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Join Fresh Choice today',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── NAME FIELD ──
              _buildLabel('Full Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                hint: 'John Doe',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: 'At least 6 characters',
                icon: Icons.lock_outline,
                obscureText: _hidePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textGrey,
                  ),
                  onPressed: () {
                    setState(() => _hidePassword = !_hidePassword);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ── TERMS CHECKBOX ──
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() => _agreedToTerms = value ?? false);
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the Terms & Privacy Policy',
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // SIGNUP BUTTON 
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // LOGIN LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.quicksand(color: AppColors.textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Log In',
                      style: GoogleFonts.quicksand(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.darkGreen,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.quicksand(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.quicksand(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.cardBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}