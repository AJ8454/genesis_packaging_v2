import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/provider/google_sign_in_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/home_page_widgets/grid_items.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kApptitle, style: kAppbarTextStyle),
      ),
      drawer: const Drawer(),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: const EdgeInsets.all(10.0),
        children: [
          GridItems(
            iconPath: 'assets/icons/open-box.svg',
            title: 'Products',
            onClicked: () => Navigator.of(context).pushNamed('/ProductScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/landscape-image.svg',
            title: 'Inventory',
            onClicked: () {},
          ),
          GridItems(
            iconPath: 'assets/icons/open-box.svg',
            title: 'Orders',
            onClicked: () {},
          ),
          GridItems(
            iconPath: 'assets/icons/open-box.svg',
            title: 'Supplier',
            onClicked: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
          ),
        ],
      ),
    );
  }
}
