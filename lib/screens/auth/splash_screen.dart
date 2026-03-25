import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
	const SplashScreen({super.key});

	@override
	State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
	late AnimationController _controller;
	late Animation<double> _logoScale;
	late Animation<double> _logoFade;
	late Animation<double> _nameFade;
	late Animation<Offset> _nameSlide;

	@override
	void initState() {
		super.initState();
		_controller = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 2200),
		);
		_logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
			CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack)),
		);
		_logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
			CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
		);
		_nameFade = Tween<double>(begin: 0.0, end: 1.0).animate(
			CurvedAnimation(parent: _controller, curve: const Interval(0.55, 1.0, curve: Curves.easeIn)),
		);
		_nameSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
			CurvedAnimation(parent: _controller, curve: const Interval(0.55, 1.0, curve: Curves.easeOut)),
		);
		_controller.forward();
		Future.delayed(const Duration(milliseconds: 2500), () {
			if (mounted) {
				context.go('/login');
			}
		});
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: kGreen,
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						AnimatedBuilder(
							animation: _controller,
							builder: (context, child) => Transform.scale(
								scale: _logoScale.value,
								child: Opacity(
									opacity: _logoFade.value,
									child: Container(
										decoration: BoxDecoration(
											shape: BoxShape.circle,
											gradient: const LinearGradient(
												colors: [kWhiteGrey, kWhite],
												begin: Alignment.topLeft,
												end: Alignment.bottomRight,
											),
											boxShadow: [
												BoxShadow(
													color: kBrown.withAlpha(30),
													blurRadius: 32,
													offset: const Offset(0, 8),
												),
											],
										),
										child: Padding(
											padding: const EdgeInsets.all(32.0),
											child: Image.asset(
												'assets/logo/attendx24_logo.jpeg',
												width: 180,
												height: 180,
											),
										),
									),
								),
							),
						),
						const SizedBox(height: 32),
						AnimatedBuilder(
							animation: _controller,
							builder: (context, child) => Opacity(
								opacity: _nameFade.value,
								child: SlideTransition(
									position: _nameSlide,
									child: child!,
								),
							),
							child: Text(
								'MMS Attendance Monitoring System',
								style: kHeaderTextStyle(context).copyWith(
									color: kWhite,
									fontSize: 32,
									letterSpacing: 1.2,
									shadows: [
										Shadow(
											color: kBrown.withAlpha(40),
											blurRadius: 12,
											offset: const Offset(0, 2),
										),
									],
								),
							),
						),
					],
				),
			),
		);
	}
}