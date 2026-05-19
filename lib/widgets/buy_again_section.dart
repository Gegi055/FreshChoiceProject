// BUY AGAIN SECTION
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
 
class BuyAgainSection extends StatelessWidget {
  const BuyAgainSection({super.key});
 
  
  static const List<Map<String, String>> _products = [
    {
      'name': 'Orange juice',
      'price': '1.50€',
      'image': 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=300',
    },
    {
      'name': 'Red Meat',
      'price': '3.50€',
      'image': 'https://images.unsplash.com/photo-1603048297172-c92544798d5a?w=300',
    },
    {
      'name': 'Orange',
      'price': '1.00€',
      'image': 'https://images.unsplash.com/photo-1547514701-42782101795e?w=300',
    },
    {
      'name': 'Bread',
      'price': '2.00€',
      'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
    },
  ];
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Buy Again',
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
 
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final product = _products[index];
              return _ProductCard(
                name: product['name']!,
                price: product['price']!,
                imageUrl: product['image']!,
              );
            },
          ),
        ),
      ],
    );
  }
}
 

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
 
  const _ProductCard({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: little flag icon + price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Mini flag (3 vertical stripes)
              Row(
                children: const [
                  _FlagStripe(color: AppColors.lightGreen),
                  _FlagStripe(color: Colors.amber),
                  _FlagStripe(color: Colors.redAccent),
                ],
              ),
              Text(
                price,
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
 
          // Product image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, _, _) =>
                    Container(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 6),
 
       
          Text(
            name,
            style: GoogleFonts.quicksand(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
 
// Tiny colored bar used in the mini flag
class _FlagStripe extends StatelessWidget {
  final Color color;
  const _FlagStripe({required this.color});
 
  @override
  Widget build(BuildContext context) {
    return Container(width: 4, height: 10, color: color);
  }
}
 