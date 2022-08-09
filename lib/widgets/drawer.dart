import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/services/auth.dart';

import '../screens/profile_screen.dart';

class NavigationDrawer extends StatefulWidget {
  final UserModel userData;
  const NavigationDrawer({required this.userData, Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
        child: Drawer(
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                const Divider(),
                _buildMenuItems(
                    onTap: () {
                      _navigateProfileScreen(context);
                    },
                    icon: const Icon(Icons.verified_user_outlined),
                    title: "Profile Screen"),
                _buildMenuItems(
                    onTap: () {
                      Navigator.pop(context);
                      AuthService().signOut();
                    },
                    icon: const Icon(Icons.logout_outlined),
                    title: "Logout"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateProfileScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileScreen(
                userModel: widget.userData,
              )),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          GestureDetector(
              onTap: () => _navigateProfileScreen(context),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.userData.imageUrl!),
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 52)),
          const SizedBox(
            height: 12,
          ),
          Text(widget.userData.name),
        ],
      ),
    );
  }

  Widget _buildMenuItems({
    required String title,
    required Icon icon,
    required Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: icon,
        onTap: onTap,
        title: Text(title),
      ),
    );
  }
}
