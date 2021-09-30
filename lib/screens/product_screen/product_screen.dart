import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List _allResult = [];
  List _searchResultList = [];
  Future? resultLoaded;
  bool? isLoading = true;
  List? data;
  _refreshProducts() async {
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        data = Provider.of<ProductProvider>(context, listen: false).items;
        setState(() {
          _allResult = data!;
          isLoading = false;
        });
      });
      searchResulList();
      return 'complete';
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      SnackBarWidget.showSnackBar(
        context,
        'No Product Added yet',
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = _refreshProducts();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    searchResulList();
  }

  searchResulList() {
    var showResult = [];
    if (_searchController.text != '') {
      showResult = _allResult.where((prod) {
        var proTitle = prod.title!.toLowerCase();
        return proTitle.contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      showResult = List.from(_allResult);
    }
    setState(() {
      _searchResultList = showResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
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
      body: isLoading!
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Column(
                children: [
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: 'search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResultList.length,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: 25,
                              child: SvgPicture.asset(
                                _searchResultList[index].imageUrl,
                                fit: BoxFit.contain,
                                height: 30,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    _searchResultList[index].title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: kCyanColor,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Type : ${_searchResultList[index].type!}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kGreyColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Color : ${_searchResultList[index].color!}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kGreyColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'BalQty : ${_searchResultList[index].quantity!.toString()}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kGreyColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 22.0,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        '/EditProductScreen',
                                        arguments: _searchResultList[index].id);
                                  },
                                  color: Colors.brown,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.trash,
                                    size: 20.0,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await Provider.of<ProductProvider>(
                                              context,
                                              listen: false)
                                          .deleteProduct(
                                              _searchResultList[index].id!);
                                      setState(() {
                                        resultLoaded = _refreshProducts();
                                      });
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
