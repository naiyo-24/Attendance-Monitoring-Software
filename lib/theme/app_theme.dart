import 'package:flutter/material.dart';
/// Responsive helper for adaptive sizing
class Responsive {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  /// Returns a responsive font size based on screen width
  static double fontSize(BuildContext context, double base) {
    double width = screenWidth(context);
    if (width >= 1200) return base * 1.4; // Desktop
    if (width >= 800) return base * 1.2; // Tablet
    if (width >= 500) return base * 1.05; // Large phone
    return base; // Small phone
  }

  /// Returns a responsive padding based on screen width
  static double padding(BuildContext context, double base) {
    double width = screenWidth(context);
    if (width >= 1200) return base * 1.5;
    if (width >= 800) return base * 1.2;
    return base;
  }
}

// Color palette (updated)
const Color kBlack = Colors.black;
const Color kBrown = Color(0xFF554E3E); // new brown shade
const Color kGreen = Color(0xFF12A30D); // new green shade
const Color kPink = Color(0xFF818080); // new pink shade
const Color kWhite = Colors.white;
const Color kWhiteGrey = Color(0xFFF5F5F7); // keep for backgrounds if needed
const Color kerror = Color(0xFFBA0E0E); // Error Color

// Extreme minimum screen padding for modern Android smartphones
const double kScreenPadding = 8.0;

// Font family from pubspec.yaml
const String kFontFamily = 'BricolageGrotesque';

// Responsive text styles (to be used with context)
TextStyle kHeaderTextStyle(BuildContext context) => TextStyle(
  fontFamily: kFontFamily,
  fontSize: Responsive.fontSize(context, 28),
  fontWeight: FontWeight.bold,
  color: kBrown,
  letterSpacing: 0.5,
);

TextStyle kTaglineTextStyle(BuildContext context) => TextStyle(
  fontFamily: kFontFamily,
  fontSize: Responsive.fontSize(context, 18),
  fontWeight: FontWeight.w500,
  color: kGreen,
  letterSpacing: 0.2,
);

TextStyle kCaptionTextStyle(BuildContext context) => TextStyle(
  fontFamily: kFontFamily,
  fontSize: Responsive.fontSize(context, 14),
  fontWeight: FontWeight.w400,
  color: kBrown,
);

TextStyle kDescriptionTextStyle(BuildContext context) => TextStyle(
  fontFamily: kFontFamily,
  fontSize: Responsive.fontSize(context, 16),
  fontWeight: FontWeight.w400,
  color: kPink,
);

// Responsive button style (to be used with context)
ButtonStyle kPremiumButtonStyle(BuildContext context) => ElevatedButton.styleFrom(
  backgroundColor: kGreen,
  foregroundColor: kWhite,
  minimumSize: Size(Responsive.padding(context, 120), Responsive.padding(context, 48)),
  padding: EdgeInsets.symmetric(
    horizontal: Responsive.padding(context, 16),
    vertical: Responsive.padding(context, 8),
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Responsive.padding(context, 16)),
  ),
  textStyle: TextStyle(
    fontFamily: kFontFamily,
    fontWeight: FontWeight.bold,
    fontSize: Responsive.fontSize(context, 16),
  ),
  elevation: 4,
);

// App logo widget (example)
class AppLogo extends StatelessWidget {
	final double size;
	final String assetPath;
	const AppLogo({
		this.size = 48,
		this.assetPath = 'assets/logo/attendx24_logo.png',
		super.key,
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			width: size,
			height: size,
			decoration: BoxDecoration(
				shape: BoxShape.circle,
				gradient: const LinearGradient(
					colors: [kWhite, kWhite],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				),
				boxShadow: [
					BoxShadow(
						color: kWhiteGrey.withAlpha(51),
						blurRadius: 8,
						offset: const Offset(0, 4),
					),
				],
			),
			child: Center(
				child: Image.asset(
					assetPath,
					width: size * 0.6,
					height: size * 0.6,
					fit: BoxFit.contain,
				),
			),
		);
	}
}

// Responsive ThemeData factory
ThemeData appTheme(BuildContext context) => ThemeData(
  fontFamily: kFontFamily,
  scaffoldBackgroundColor: kWhite,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: kBrown,
    onPrimary: kWhite,
    secondary: kGreen,
    onSecondary: kWhite,
    surface: kWhiteGrey,
    onSurface: kBrown,
    error: kPink,
    onError: kWhite,
  ),
  textTheme: TextTheme(
    displayLarge: kHeaderTextStyle(context),
    titleLarge: kTaglineTextStyle(context),
    bodySmall: kCaptionTextStyle(context),
    bodyMedium: kDescriptionTextStyle(context),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: kPremiumButtonStyle(context),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kWhiteGrey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Responsive.padding(context, 12)),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: Responsive.padding(context, 12),
      vertical: Responsive.padding(context, 8),
    ),
    hintStyle: TextStyle(
      color: kBrown,
      fontFamily: kFontFamily,
      fontSize: Responsive.fontSize(context, 14),
    ),
  ),
);