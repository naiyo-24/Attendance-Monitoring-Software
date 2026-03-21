import 'package:flutter/material.dart';

class SideNavBar extends StatelessWidget {
	final void Function(String route)? onNavigate;
	const SideNavBar({super.key, this.onNavigate});

	@override
	Widget build(BuildContext context) {
		return Drawer(
			child: ListView(
				padding: EdgeInsets.zero,
				children: [
					DrawerHeader(
						decoration: BoxDecoration(
							color: Colors.brown[100],
						),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: const [
								Text('Admin Panel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
								SizedBox(height: 8),
								Text('Welcome!', style: TextStyle(fontSize: 16)),
							],
						),
					),
					_drawerItem(context, Icons.dashboard, 'Dashboard', '/dashboard'),
					_drawerItem(context, Icons.location_on, 'Set Location Matrix', '/set-location-matrix'),
					_drawerItem(context, Icons.person_add, 'Onboard Employees', '/onboard-employees'),
					_drawerItem(context, Icons.calendar_today, 'Holiday List', '/holiday-list'),
					_drawerItem(context, Icons.beach_access, 'Leave Applications', '/leave-applications'),
					_drawerItem(context, Icons.receipt_long, 'Salary Slip', '/salary-slip'),
					_drawerItem(context, Icons.notifications, 'Notification Management', '/notification-management'),
					_drawerItem(context, Icons.help_center, 'Help Center', '/help-center'),
					const Divider(),
					_drawerItem(context, Icons.logout, 'Log Out', '/logout'),
				],
			),
		);
	}

	Widget _drawerItem(BuildContext context, IconData icon, String title, String route) {
		return ListTile(
			leading: Icon(icon),
			title: Text(title),
			onTap: () {
				Navigator.of(context).pop();
				if (onNavigate != null) {
					onNavigate!(route);
				} else {
					// Default: try to use Navigator
					Navigator.of(context).pushNamed(route);
				}
			},
		);
	}
}
