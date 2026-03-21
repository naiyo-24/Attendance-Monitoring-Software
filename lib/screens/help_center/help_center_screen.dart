import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../cards/help_center/header_card.dart';
import '../../cards/help_center/contact_card.dart';
import '../../notifiers/help_center_notifier.dart';
import '../../providers/help_center_provider.dart';
import '../../models/help_center.dart';
import '../../widgets/side_nav_bar.dart';

class HelpCenterScreen extends StatefulWidget {
	const HelpCenterScreen({super.key});

	@override
	State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
	late HelpCenterNotifier helpCenterNotifier;

	@override
	void initState() {
		super.initState();
		helpCenterNotifier = HelpCenterNotifier();
		// Demo data for Naiyo24 Pvt. Ltd.
		helpCenterNotifier.setHelpCenter(
			HelpCenter(
				logoPath: 'assets/logo/naiyo24_logo.png',
				header: 'Naiyo24 Pvt. Ltd.',
				tagline: 'Your trusted HR & Payroll partner',
				description: 'Naiyo24 is a leading HR and payroll management company, providing innovative solutions for businesses of all sizes. Our platform streamlines attendance, payroll, and employee management with a focus on security and user experience.',
				phone: '+91 98765 43210',
				email: 'support@naiyo24.com',
				address: '2nd Floor, Tech Park, Salt Lake, Kolkata, West Bengal, 700091',
				website: 'https://naiyo24.com',
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return HelpCenterProvider(
			notifier: helpCenterNotifier,
			child: Scaffold(
				appBar: const PremiumAppBar(
					title: 'Help Center',
					subtitle: 'Contact and company information',
				),
        drawer: const SideNavBar(),
				body: Padding(
					padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							HeaderCard(helpCenter: helpCenterNotifier.helpCenter!),
							ContactCard(helpCenter: helpCenterNotifier.helpCenter!),
						],
					),
				),
			),
		);
	}
}
