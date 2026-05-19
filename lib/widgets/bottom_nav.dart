import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
 
class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
 
  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });
 
  static const List<IconData> _icons = [
    Icons.home_rounded,        // 0 Home
    Icons.local_offer_outlined, // 1 Deals / tag
    Icons.menu_book_outlined,   // 2 Menu
    Icons.restaurant,           // 3 Food
    Icons.shopping_basket,      // 4 Cart
  ];
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Icon(
                  _icons[index],
                  size: 26,
                  color: isSelected
                      ? AppColors.primary  // green when selected
                      : AppColors.textGrey, // grey otherwise
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
