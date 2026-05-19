import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../screens/login_screen.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search box 
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                Icon(Icons.search, color: AppColors.textGrey),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // PROFILE ICON BUTTON 
        GestureDetector(
          onTap: () {
            // Open the login screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.darkGreen,
            ),
          ),
        ),
      ],
    );
  }
}