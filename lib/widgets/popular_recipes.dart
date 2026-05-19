import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
 
class PopularRecipes extends StatelessWidget {
  const PopularRecipes({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Recipes',
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              'View All',
              style: GoogleFonts.quicksand(
                fontSize: 13,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
 
        // The recipe cards
        SizedBox(
          height: 220,
          child: Row(
            children: [
              // First card
              Expanded(
                flex: 5, 
                child: _RecipeCard(
                  title: 'Our\nTop Picks',
                  imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
                  titleSize: 22,
                ),
              ),
 
              const SizedBox(width: 10),
 
             
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Expanded(
                      child: _RecipeCard(
                        title: 'Hangover\nFoods',
                        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
                        titleSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _RecipeCard(
                        title: 'Remedy\nFoods',
                        imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400',
                        titleSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
 

class _RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double titleSize;
 
  const _RecipeCard({
    required this.title,
    required this.imageUrl,
    required this.titleSize,
  });
 
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: AppColors.midGreen),
          ),
 
          // Dark overlay so white text is readable
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
 
          // Title text
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: GoogleFonts.anton(
                  fontSize: titleSize,
                  color: AppColors.white,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
