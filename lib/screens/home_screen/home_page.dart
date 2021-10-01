import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/provider/customer_provider.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/provider/vendor_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';
import 'package:genesis_packaging_v2/widgets/home_page_widgets/grid_items.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).fetchAndSetProducts();
    Provider.of<VendorProvider>(context, listen: false).fetchAndSetVendor();
    Provider.of<CustomerProvider>(context, listen: false).fetchAndSetCustomer();
    super.didChangeDependencies();
  }

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
            onClicked: () =>
                Navigator.of(context).pushNamed('/PurchaseEntryScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/salesEntry.svg',
            title: 'Sales Entry',
            onClicked: () =>
                Navigator.of(context).pushNamed('/SalesEntryScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/productList.svg',
            title: 'Product List',
            onClicked: () => Navigator.of(context).pushNamed('/ProductScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/closingStock.svg',
            title: 'Closing Stock',
            onClicked: () => SnackBarWidget.showSnackBar(
              context,
              'Coming soon',
            ),
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
            onClicked: () =>
                Navigator.of(context).pushNamed('/CustomerDetailScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/person.svg',
            title: 'Employees',
            onClicked: () => Navigator.of(context).pushNamed('/EmployeeScreen'),
          ),
          GridItems(
            iconPath: 'assets/icons/attendance.svg',
            title: 'Attendance',
            onClicked: () => SnackBarWidget.showSnackBar(
              context,
              'Coming soon',
            ),
          ),
        ],
      ),
    );
  }
}
