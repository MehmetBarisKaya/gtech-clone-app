import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/provider/user_provider.dart';
import 'package:gtech/services/auth.dart';
import 'package:provider/provider.dart';

import '../screens/profile_screen.dart';

class NavigationDrawer extends StatefulWidget {
  ///final UserModel userData;
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  //late Future _userDataFuture;
  Future _getDrawerData() async {
    return await Provider.of<UserProvider>(context).getData();
  }

  @override
  void initState() {
    //_userDataFuture = _getDrawerData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context);
    UserModel _userModel = _userData.userDataModel;
    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
        child: Drawer(
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, _userModel),
                const Divider(),
                _buildMenuItems(
                    onTap: () {
                      _navigateProfileScreen(context, _userData.userDataModel);
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

  void _navigateProfileScreen(BuildContext context, UserModel userData) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileScreen(
                userModel: userData,
              )),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel _userModel) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          GestureDetector(
              onTap: () => _navigateProfileScreen(context, _userModel),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(_userModel.imageUrl!),
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 52)),
          const SizedBox(
            height: 12,
          ),
          Text(_userModel.name!),
        ],
      ),
    );
  }
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
