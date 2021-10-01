import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';

class PurchaseEntryScreen extends StatelessWidget {
  const PurchaseEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Entry', style: kAppbarTextStyle),
      ),
      drawer: const AppDrawer(),
    );
  }
}
