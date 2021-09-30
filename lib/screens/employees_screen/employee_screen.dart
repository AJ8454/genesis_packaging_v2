import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/provider/employee_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List _allResult = [];
  List _searchResultList = [];
  Future? resultLoaded;
  bool? isLoading = true;
  List? data;
  _refreshEmployee() async {
    try {
      await Provider.of<EmployeeProvider>(context, listen: false)
          .fetchAndSetEmployee()
          .then((_) {
        data = Provider.of<EmployeeProvider>(context, listen: false).worker;
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
        'No Employee Added yet',
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultLoaded = _refreshEmployee();
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
          'Employees',
          style: kAppbarTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed('/EditEmployeeScreen'),
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
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          leading: SvgPicture.asset(
                            _searchResultList[index].imageUrl,
                            height: 30,
                          ),
                          title: Text(
                            _searchResultList[index].name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              color: kCyanColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              const Text(
                                'Wages :',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kGreyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _searchResultList[index].wages!.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kGreyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                                  Navigator.of(context).pushNamed(
                                      '/EditEmployeeScreen',
                                      arguments: _searchResultList[index].id);
                                },
                                color: Colors.brown,
                              ),
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                  size: 18.0,
                                ),
                                onPressed: () async {
                                  try {
                                    await Provider.of<EmployeeProvider>(context,
                                            listen: false)
                                        .deleteEmployee(
                                            _searchResultList[index].id!);
                                    setState(() {
                                      resultLoaded = _refreshEmployee();
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
