import 'package:flutter/material.dart';


class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'assets/logo/attendx24_logo.jpeg',
        fit: BoxFit.fitWidth,
        width: double.infinity,
        alignment: Alignment.center,
        
      ),
    );
  }
}