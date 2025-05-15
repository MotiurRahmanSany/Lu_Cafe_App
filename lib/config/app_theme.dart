import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange).copyWith(
    surface: Colors.white,
    onSurface: Colors.black,
    
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);