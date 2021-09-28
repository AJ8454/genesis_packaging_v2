import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/models/product.dart';
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
  late List<Product> _product = [];
  late List<Product> _productForDisplay = [];

  Future<void> _refreshProducts(BuildContext context) async {
    try {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.fetchAndSetProducts();
      _product = provider.items;
      _productForDisplay = provider.items;
    } catch (error) {
      SnackBarWidget.showSnackBar(
        context,
        'No Product Added yet',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: kAppbarTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: _productForDisplay.length + 1,
            itemBuilder: (context, index) {
              if (_productForDisplay.isEmpty) {
                Future.delayed(const Duration(seconds: 3))
                    .then((_) => setState(() {
                          _refreshProducts(context);
                        }));
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return index == 0 ? _searchBar() : _productItem(index - 1);
            }),
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

  _searchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'search...',
          border: InputBorder.none,
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _productForDisplay = _product.where((prod) {
              var proTitle = prod.title!.toLowerCase();
              return proTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _productItem(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          leading: SvgPicture.asset(
            _productForDisplay[index].imageUrl,
            height: 30,
          ),
          title: Text(
            _productForDisplay[index].title!,
            style: const TextStyle(
              fontSize: 15,
              color: kCyanColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          subtitle: Text(
            _productForDisplay[index].type!,
            style: const TextStyle(
              fontSize: 9,
              color: kGreyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 22.0,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/stockEditScreen',
                      arguments: _productForDisplay[index].id);
                },
                color: Colors.brown,
              ),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.trash,
                  size: 22.0,
                ),
                onPressed: () async {
                  try {
                    await Provider.of<ProductProvider>(context, listen: false)
                        .deleteProduct(_productForDisplay[index].id!);
                  } catch (error) {
                    SnackBarWidget.showSnackBar(
                      context,
                      'Deleting Failed',
                    );
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
