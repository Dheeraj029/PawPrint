import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a premium color palette
const Color premiumPrimaryColor = Color(0xFF1A3A3A); // Dark teal
const Color premiumAccentColor = Color(0xFFFABE50); // Soft gold
const Color premiumBackgroundColor = Color(0xFF121212); // Very dark background
const Color premiumCardColor = Color(0xFF2C2C2C); // Dark grey card
const Color premiumTextColor =
    Color(0xFFF5F5F5); // Light text color for better contrast
const Color premiumSecondaryTextColor =
    Color(0xFFB0B0B0); // Subtle grey text color

var appTheme = ThemeData(
  fontFamily: GoogleFonts.nunito().fontFamily,
  brightness: Brightness.dark,

  // Primary Color (Dark teal)
  primaryColor: premiumPrimaryColor,

  // Background Color (Dark with soft contrast)
  scaffoldBackgroundColor: premiumBackgroundColor,

  // AppBar Theme
  appBarTheme: AppBarTheme(
    color: premiumPrimaryColor,
    elevation: 0, // No shadow for a cleaner look
    titleTextStyle: TextStyle(
      color: premiumTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    iconTheme:
        IconThemeData(color: premiumAccentColor), // Accent color for icons
  ),

  // Bottom AppBar Theme
  bottomAppBarTheme: BottomAppBarTheme(
    color: premiumPrimaryColor,
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: premiumAccentColor, // Gold accent for FAB
  ),

  // TextTheme (refined for premium design)
  textTheme: TextTheme(
    // Main body text
    bodyLarge:
        TextStyle(fontSize: 18, color: premiumTextColor), // Main body text
    bodyMedium:
        TextStyle(fontSize: 16, color: premiumTextColor), // Smaller body text

    // Large Body Text (Primary content text)
    titleLarge: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w400, color: premiumTextColor),

    // Medium Body Text
    titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: premiumSecondaryTextColor),

    // Bold Label Text (for buttons and labels)
    labelLarge: TextStyle(
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: premiumAccentColor, // Use accent color for labels
    ),

    // Display large text (Headings, Titles)
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: premiumTextColor,
    ),

    // Medium Titles (for smaller headings)
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: premiumSecondaryTextColor,
    ),

    // White text for prominent sections
    displaySmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: premiumTextColor,
    ),
  ),

  // Button Theme
  buttonTheme: ButtonThemeData(
    buttonColor: premiumAccentColor, // Gold for buttons
    textTheme: ButtonTextTheme.primary, // Make button text stand out
  ),

  // Card Theme (for cards with rounded edges and shadow)
  cardTheme: CardTheme(
    color: premiumCardColor, // Dark grey cards
    elevation: 5, // Subtle shadow for cards
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Rounded edges for cards
    ),
  ),

  // Input Decoration Theme (for text fields)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: premiumBackgroundColor,
    labelStyle: TextStyle(color: premiumAccentColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: premiumAccentColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: premiumAccentColor),
    ),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: premiumPrimaryColor,
    selectedItemColor: premiumAccentColor,
    unselectedItemColor: premiumSecondaryTextColor,
  ),
);
