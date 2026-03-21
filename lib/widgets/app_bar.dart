import 'package:flutter/material.dart';
import '../theme/app_theme.dart';



class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const PremiumAppBar({
    required this.title,
    required this.subtitle,
    this.scaffoldKey,
    super.key,
  });



  @override
  Size get preferredSize => const Size.fromHeight(60);


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kWhite,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: kBlack),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kHeaderTextStyle(context).copyWith(color: kBlack, fontSize: 20),
          ),
          Text(
            subtitle,
            style: kTaglineTextStyle(context).copyWith(color: kBrown, fontSize: 14),
          ),
        ],
      ),
      centerTitle: false,
    );
  }
}