import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
 
void main() {
  runApp(const FreshChoiceApp());
}
 
class FreshChoiceApp extends StatelessWidget {
  const FreshChoiceApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fresh Choice',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        
        textTheme: GoogleFonts.quicksandTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      home: HomeScreen(),
    );
  }
}
