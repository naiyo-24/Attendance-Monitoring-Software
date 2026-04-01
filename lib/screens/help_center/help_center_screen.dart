import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifiers/auth_notifier.dart';
import '../../notifiers/help_center_notifier.dart';
import '../../widgets/app_bar.dart';
import '../../cards/help_center/header_card.dart';
import '../../cards/help_center/contact_card.dart';
import '../../providers/help_center_provider.dart';
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
		WidgetsBinding.instance.addPostFrameCallback((_) {
			helpCenterNotifier.fetchHelpCenter();
		});
	}

	@override
	Widget build(BuildContext context) {
				return HelpCenterProvider(
					notifier: helpCenterNotifier,
					child: Builder(
						builder: (context) {
							final notifier = HelpCenterProvider.of(context);
							final auth = Provider.of<AuthNotifier>(context, listen: false);
							return Scaffold(
								appBar: const PremiumAppBar(
									title: 'Help Center',
									subtitle: 'Contact and company information',
								),
								drawer: SideNavBar(adminUser: auth.user!),
								body: Padding(
									padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
									child: Builder(
										builder: (context) {
											if (notifier.isLoading) {
												return const Center(child: CircularProgressIndicator());
											} else if (notifier.error != null) {
												return Center(child: Text('Error: ${notifier.error}'));
											} else if (notifier.helpCenter == null) {
												return const Center(child: Text('No help center data available.'));
											}
											return Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													HeaderCard(helpCenter: notifier.helpCenter!),
													ContactCard(helpCenter: notifier.helpCenter!),
												],
											);
										},
									),
								),
							);
						},
					),
				);
	}
}
