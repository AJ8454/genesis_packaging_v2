import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/provider/google_sign_in_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        child: Drawer(
          elevation: 8,
          child: ListView(children: [
            const SizedBox(
              height: 60,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: kCyanColor,
                ),
                child: Text(
                  'Genesis Packaging',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const DrawerListTile(
              name: 'Products',
              icon: Icons.production_quantity_limits,
              navigate: '/ProductScreen',
            ),
            const DrawerListTile(
              name: 'Employees',
              icon: Icons.person,
              navigate: '/EmployeeScreen',
            ),
            const DrawerListTile(
              name: 'Attendance',
              icon: Icons.group,
              navigate: '/OrderScreen',
            ),
            const DrawerListTile(
              name: 'Orders',
              icon: Icons.local_shipping_rounded,
              navigate: '/OrderScreen',
            ),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    color: kCyanColor,
                  ),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: kDarkColor,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 13),
              ),
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String? name, navigate;
  final IconData icon;

  const DrawerListTile({
    Key? key,
    required this.name,
    required this.navigate,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: kDarkColor,
      ),
      title: Text(
        name!,
        style: const TextStyle(fontSize: 13),
      ),
      onTap: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushNamed(navigate!);
      },
    );
  }
}
