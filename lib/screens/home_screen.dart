
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/popular_recipes.dart';
import '../widgets/buy_again_section.dart';
import '../widgets/today_menu_banner.dart';
import '../widgets/bottom_nav.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0; // 0 = Home is selected
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // SafeArea keeps content away from the phone notch 
      body: SafeArea(
        child: SingleChildScrollView(
          // user can scroll the whole page
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
 
              // Search bar + profile icon
              const SearchBarWidget(),
 
              const SizedBox(height: 24),
 
              
              const PopularRecipes(),
 
              const SizedBox(height: 24),
 
              
              const BuyAgainSection(),
 
              const SizedBox(height: 20),
 
             
              const TodayMenuBanner(),
 
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
 
      
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
      ),
    );
  }
}
