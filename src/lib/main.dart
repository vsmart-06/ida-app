import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:src/pages/event_page.dart';
import 'package:src/pages/events_page.dart';
import 'package:src/pages/home_page.dart';
import 'package:src/pages/login_page.dart';
import 'package:src/pages/map_page.dart';
import 'package:src/pages/shop_page.dart';
import 'package:src/pages/signup_page.dart';
import 'package:src/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      routes: {
        "/splash": (context) => SplashPage(),
        "/": (context) => LoginPage(),
        "/signup": (context) => SignupPage(),
        "/home": (context) => HomePage(),
        "/shop": (context) => ShopPage(),
        "/events": (context) => EventsPage(),
        "/event": (context) => EventPage(),
        "/map": (context) => MapPage()
      },
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(overlayColor: WidgetStatePropertyAll(Color(0x3313294B)), textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.normal)))),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
        primaryColor: Color(0xFF9C9A9D),
        primaryColorLight: Color(0xFFFF5F05),
        primaryColorDark: Color(0xFF13294B),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF13294B),
          surfaceTintColor: Colors.transparent
        ),
        typography: Typography(
          black: TextTheme(
            headlineLarge: TextStyle(fontSize: 26, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            headlineMedium: TextStyle(fontSize: 24, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            headlineSmall: TextStyle(fontSize: 22, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            titleLarge: TextStyle(fontSize: 26, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            titleMedium: TextStyle(fontSize: 24, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            titleSmall: TextStyle(fontSize: 22, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            bodyLarge: TextStyle(fontSize: 18, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            bodyMedium: TextStyle(fontSize: 14, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            bodySmall: TextStyle(fontSize: 12, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            labelLarge: TextStyle(fontSize: 18, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            labelMedium: TextStyle(fontSize: 14, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.black),
            labelSmall: TextStyle(fontSize: 12, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.black), 
          ),
          white: TextTheme(
            headlineLarge: TextStyle(fontSize: 26, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            headlineMedium: TextStyle(fontSize: 24, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            headlineSmall: TextStyle(fontSize: 22, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            titleLarge: TextStyle(fontSize: 26, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            titleMedium: TextStyle(fontSize: 24, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            titleSmall: TextStyle(fontSize: 22, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            bodyLarge: TextStyle(fontSize: 18, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 14, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            bodySmall: TextStyle(fontSize: 12, fontFamily: GoogleFonts.sourceSans3().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            labelLarge: TextStyle(fontSize: 18, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            labelMedium: TextStyle(fontSize: 14, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.white),
            labelSmall: TextStyle(fontSize: 12, fontFamily: GoogleFonts.montserrat().fontFamily, fontWeight: FontWeight.normal, color: Colors.white), 
          ),
        )
      ),
    )
  );
}