import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/product_page_widgets/product_item_widgets.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchAndSetProducts();
    } catch (error) {
      SnackBarWidget.showSnackBar(
        context,
        'No Product Added yet',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: kAppbarTextStyle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _refreshProducts(context),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : productData.items.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/open-box.svg',
                                    height: 80,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Add your product',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListView.builder(
                                itemCount: productData.items.length,
                                itemBuilder: (_, i) {
                                  return ProductItem(
                                    id: productData.items[i].id!,
                                    title: productData.items[i].title!,
                                    imageUrl: productData.items[i].imageUrl,
                                    type: productData.items[i].type,
                                  );
                                },
                              ),
                            ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFAB10C),
        child: SvgPicture.asset(
          'assets/icons/emptyBox.svg',
          color: Colors.white,
          height: 30,
        ),
        onPressed: () => Navigator.of(context).pushNamed('/EditProductScreen'),
      ),
    );
  }
}
