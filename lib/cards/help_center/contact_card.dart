import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/help_center.dart';
import '../../theme/app_theme.dart';

class ContactCard extends StatelessWidget {
	final HelpCenter helpCenter;
	const ContactCard({super.key, required this.helpCenter});

	void _launchUrl(String url) async {
		final uri = Uri.parse(url);
		if (await canLaunchUrl(uri)) {
			await launchUrl(uri);
		}
	}

	@override
		Widget build(BuildContext context) {
				return Card(
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
						color: kWhite,
						elevation: 2,
						margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
						child: Padding(
								padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
								child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
												if (helpCenter.phone.isNotEmpty)
													Row(
														children: [
															const Icon(Icons.phone, color: kGreen),
															const SizedBox(width: 10),
															GestureDetector(
																onTap: () => _launchUrl('tel:${helpCenter.phone}'),
																child: Text(helpCenter.phone, style: kDescriptionTextStyle(context).copyWith(color: kGreen, decoration: TextDecoration.underline)),
															),
														],
													),
												if (helpCenter.phone.isNotEmpty) const SizedBox(height: 10),
												if (helpCenter.email.isNotEmpty)
													Row(
														children: [
															const Icon(Icons.email, color: kBrown),
															const SizedBox(width: 10),
															GestureDetector(
																onTap: () => _launchUrl('mailto:${helpCenter.email}'),
																child: Text(helpCenter.email, style: kDescriptionTextStyle(context).copyWith(color: kBrown, decoration: TextDecoration.underline)),
															),
														],
													),
												if (helpCenter.email.isNotEmpty) const SizedBox(height: 10),
												if (helpCenter.address.isNotEmpty)
													Row(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															const Icon(Icons.location_on, color: kPink),
															const SizedBox(width: 10),
															Expanded(child: Text(helpCenter.address, style: kDescriptionTextStyle(context))),
														],
													),
												if (helpCenter.address.isNotEmpty) const SizedBox(height: 10),
												if (helpCenter.website.isNotEmpty)
													Row(
														children: [
															const Icon(Icons.language, color: kGreen),
															const SizedBox(width: 10),
															GestureDetector(
																onTap: () => _launchUrl(helpCenter.website),
																child: Text(helpCenter.website, style: kDescriptionTextStyle(context).copyWith(color: kGreen, decoration: TextDecoration.underline)),
															),
														],
													),
										],
								),
						),
				);
		}
}
