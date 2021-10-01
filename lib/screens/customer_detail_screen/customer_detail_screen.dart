import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/provider/customer_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';
import 'package:genesis_packaging_v2/widgets/customer_page_widget/customer_item_widget.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({Key? key}) : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  List _allResult = [];
  List _searchResultList = [];
  Future? resultLoaded;
  bool? isLoading = true;
  List? data;
  _refreshCustomer() async {
    try {
      await Provider.of<CustomerProvider>(context, listen: false)
          .fetchAndSetCustomer()
          .then((_) {
        data = Provider.of<CustomerProvider>(context, listen: false).items;
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
        'No Customer Added yet',
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = _refreshCustomer();
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
        var proName = prod.name!.toLowerCase();
        return proName.contains(_searchController.text.toLowerCase());
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
          'Customer Details',
          style: kAppbarTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed('/EditCustomerScreen'),
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
                        hintText: 'search by name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResultList.length,
                      itemBuilder: (context, index) => CustomerItem(
                        id: _searchResultList[index].id,
                        companyName: _searchResultList[index].companyName,
                        address: _searchResultList[index].customerAddress,
                        name: _searchResultList[index].name,
                        customerMobileNo: _searchResultList[index]
                            .customerMobileNum
                            .toString(),
                        customerEmail: _searchResultList[index].customerEmail,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
