import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';
import 'package:genesis_packaging_v2/widgets/home_page_widgets/grid_items.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kApptitle, style: kAppbarTextStyle),
      ),
      drawer: const AppDrawer(),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        padding: const EdgeInsets.all(10.0),
        children: [
          GridItems(
            iconPath: 'assets/icons/purchaseEntry.svg',
            title: 'Purchase Entry',
            onClicked: () => Navigator.of(context).pushNamed('/ProductScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/salesEntry.svg',
            title: 'Sales Entry',
            onClicked: () => Navigator.of(context).pushNamed('/ProductScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/productList.svg',
            title: 'Product List',
            onClicked: () => Navigator.of(context).pushNamed('/ProductScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/productList.svg',
            title: 'Closing Stock',
            onClicked: () => Navigator.of(context).pushNamed('/ProductScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/vendor.svg',
            title: 'Vendor Detail',
            onClicked: () =>
                Navigator.of(context).pushNamed('/VendorDetailScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/customers.svg',
            title: 'Customer Detail',
            onClicked: () => Navigator.of(context).pushNamed('/ProductScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/orders.svg',
            title: 'Orders',
            onClicked: () => Navigator.of(context).pushNamed('/OrderScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/person.svg',
            title: 'Employees',
            onClicked: () => Navigator.of(context).pushNamed('/EmployeeScreen'),
          ),
          // GridItems(
          //   iconPath: 'assets/icons/attandancePerson.svg',
          //   title: 'Attendance',
          //   onClicked: () => Navigator.of(context).pushNamed('/EmployeeScreen'),
          // ),
        ],
      ),
    );
  }
}
