import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: kAppbarTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed('/EditProductScreen'),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}
