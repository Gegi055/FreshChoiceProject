import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
 
class TodayMenuBanner extends StatelessWidget {
  const TodayMenuBanner({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A5F), Color(0xFF2C5282)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circle (top-right)
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
 
          // Banner text centered
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Today's",
                  style: GoogleFonts.anton(
                    fontSize: 28,
                    color: const Color(0xFFFFD93D), // yellow
                    height: 1.0,
                  ),
                ),
                Text(
                  'food menu',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFFFFD93D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 