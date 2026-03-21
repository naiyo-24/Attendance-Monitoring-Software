import 'package:flutter/material.dart';


class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'assets/logo/logo_no_bg.png',
        fit: BoxFit.fitWidth,
        width: double.infinity,
        alignment: Alignment.center,
        
      ),
    );
  }
}