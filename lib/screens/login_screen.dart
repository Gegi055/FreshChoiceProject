import 'package:flutter/material.dart';
import 'package:fresh_choice/screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'signup_screen.dart'; // fix
 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
 
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  // Controllers grab the text the user types
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true; // toggles password visibility
 
  // Clean up controllers when screen closes (good practice)
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 
  // What happens when user taps the Login button
  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
 
    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
 
    // TODO: Connect to your Python backend here later
    // For now, just show a success message and go back home
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome back, $email!'),
        backgroundColor: AppColors.primary,
      ),
    );
 
    // Go back to the home screen
    Navigator.pop(context);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // Top bar with back button
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
              const SizedBox(height: 20),
 
              // ── BIG LEAF LOGO/HEADER ──
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.eco,
                    size: 44,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),
 
              // ── TITLE ──
              Center(
                child: Text(
                  'Welcome Back',
                  style: GoogleFonts.anton(
                    fontSize: 32,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Log in to your Fresh Choice account',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 40),
 
              // ── EMAIL FIELD ──
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
 
              // ── PASSWORD FIELD ──
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: '••••••••',
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
              const SizedBox(height: 12),
 
              // ── FORGOT PASSWORD LINK ──
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Add forgot password page later
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.quicksand(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
 
              // ── LOGIN BUTTON ──
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Log In',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
 
              // ── "OR" DIVIDER ──
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: GoogleFonts.quicksand(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),
 
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.quicksand(color: AppColors.textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Replace this screen with the sign up screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
 
  // ── Helper widget for field labels ──
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
 
  // ── Reusable text field builder ──
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