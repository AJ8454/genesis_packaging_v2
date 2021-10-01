import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_packaging_v2/models/customer.dart';
import 'package:genesis_packaging_v2/models/product.dart';
import 'package:genesis_packaging_v2/models/sales_entry.dart';
import 'package:genesis_packaging_v2/provider/customer_provider.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/provider/sales_entry_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesEntryScreen extends StatefulWidget {
  const SalesEntryScreen({Key? key}) : super(key: key);

  @override
  State<SalesEntryScreen> createState() => _SalesEntryScreenState();
}

class _SalesEntryScreenState extends State<SalesEntryScreen> {
  var _isLoading = false;
  String? selectedProductValue;
  String? selectedCustomerValue;
  List<Product>? product;
  List<Product>? selectedProduct;
  List<Customer>? customer;
  List<Customer>? selectedCustomer;
  TextEditingController salesQtyController = TextEditingController();
  int? getTotalProductQty;
  String? idToUpdateQty;
  final FocusScopeNode _node = FocusScopeNode();
  final _form = GlobalKey<FormState>();
  var _editSalesEntry = SalesEntry(
    id: null,
    productName: '',
    customerName: '',
    salesQty: 0,
    salesDateTime: '',
    salesPrice: 0.0,
    salesType: '',
  );

  var _updateProductQty = Product(
    id: null,
    title: '',
    alertQty: 0,
    color: '',
    dateTime: '',
    gstNo: '',
    rate: 0.0,
    supplier: '',
    size: 0.0,
    imageUrl: '',
    quantity: 0,
    type: '',
  );

  DateTime? date;
  String? uploadDate;
  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return DateFormat('dd/MM/yyyy').format(date!);
    }
  }

  @override
  void initState() {
    final productData = Provider.of<ProductProvider>(context, listen: false);
    final customerData = Provider.of<CustomerProvider>(context, listen: false);
    super.initState();
    product = productData.items.toList();
    customer = customerData.items.toList();
    selectedProduct = product;
    selectedCustomer = customer;
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<SalesEntryProvider>(context, listen: false)
        .addsSalesEntry(_editSalesEntry);

    await Provider.of<ProductProvider>(context, listen: false)
        .updateProduct(idToUpdateQty!, _updateProductQty)
        .then(
          (_) => SnackBarWidget.showSnackBar(
            context,
            'SalesEntry saved',
          ),
        );
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Entry', style: kAppbarTextStyle),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                  child: Column(
                    children: [
                      FocusScope(
                        node: _node,
                        child: Form(
                          key: _form,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Product Name'),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: buildProductNameDropdown()),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed('/EditProductScreen'),
                                      icon: SvgPicture.asset(
                                        'assets/icons/plus.svg',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const Text('Customer Name'),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: buildVendorNameDropdown()),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed('/EditCustomerScreen'),
                                      icon: SvgPicture.asset(
                                        'assets/icons/plus.svg',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: salesQtyController,
                                decoration: const InputDecoration(
                                  labelText: 'Sales Qty',
                                  labelStyle: TextStyle(fontSize: 12),
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editSalesEntry = SalesEntry(
                                    id: _editSalesEntry.id,
                                    productName: selectedProductValue,
                                    customerName: selectedCustomerValue,
                                    salesQty: int.parse(value!),
                                    salesDateTime:
                                        _editSalesEntry.salesDateTime,
                                    salesPrice: _editSalesEntry.salesPrice,
                                    salesType: _editSalesEntry.salesType,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter purchase quantity.';
                                  }
                                  return null;
                                },
                              ),
                              ..._quantityField(),
                              const SizedBox(height: 15),
                              const Text('Sales Date'),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 8,
                                  primary: kCyanColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                ),
                                child: Text(
                                  getText(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () => pickDate(context),
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Sales Price',
                                  labelStyle: TextStyle(fontSize: 12),
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editSalesEntry = SalesEntry(
                                    id: _editSalesEntry.id,
                                    productName: selectedProductValue,
                                    customerName: selectedCustomerValue,
                                    salesQty: _editSalesEntry.salesQty,
                                    salesDateTime:
                                        _editSalesEntry.salesDateTime,
                                    salesPrice: double.parse(value!),
                                    salesType: _editSalesEntry.salesType,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter purchase price.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Sales Type (cash/cheque...)',
                                  labelStyle: TextStyle(fontSize: 12),
                                ),
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editSalesEntry = SalesEntry(
                                    id: _editSalesEntry.id,
                                    productName: selectedProductValue,
                                    customerName: selectedCustomerValue,
                                    salesQty: _editSalesEntry.salesQty,
                                    salesDateTime:
                                        _editSalesEntry.salesDateTime,
                                    salesPrice: _editSalesEntry.salesPrice,
                                    salesType: value!,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter purchase type.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 50),
                                    primary: kCyanColor,
                                    elevation: 8,
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () => _submitForm(),
                                  child: const Icon(Icons.check),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildProductNameDropdown() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black38, width: 2),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              isExpanded: true,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              hint: const Text('Select Product'),
              items: product!.map((item) {
                return DropdownMenuItem(
                  child: Text(item.title!),
                  value: item.title,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedProductValue = newValue as String?;
                });
              },
              value: selectedProductValue,
            ),
          ),
        ),
      );

  Widget buildVendorNameDropdown() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black38, width: 2),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              isExpanded: true,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              hint: const Text('Select Customer'),
              items: customer!.map((item) {
                return DropdownMenuItem(
                  child: Text(item.name!),
                  value: item.name,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCustomerValue = newValue as String?;
                });
              },
              value: selectedCustomerValue,
            ),
          ),
        ),
      );

  _quantityField() {
    return selectedProduct!.asMap().entries.map((product) {
      int idx = product.key;
      idToUpdateQty = selectedProduct![idx].id;
      if (salesQtyController.text.isEmpty) {
        return selectedProduct![idx].title == selectedProductValue
            ? selectedProductValue != null
                ? Text(
                    'Note: Available Quantity is ${selectedProduct![idx].quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: kCyanColor,
                    ),
                  )
                : Container()
            : Container();
      } else {
        getTotalProductQty = (selectedProduct![idx].quantity! -
            int.parse(salesQtyController.text));
        _updateProductQty = Product(
          title: selectedProduct![idx].title,
          id: selectedProduct![idx].id,
          color: selectedProduct![idx].color,
          dateTime: selectedProduct![idx].dateTime,
          gstNo: selectedProduct![idx].gstNo,
          imageUrl: selectedProduct![idx].imageUrl,
          quantity: getTotalProductQty,
          rate: selectedProduct![idx].rate,
          size: selectedProduct![idx].size,
          supplier: selectedProduct![idx].supplier,
          alertQty: selectedProduct![idx].alertQty,
          type: selectedProduct![idx].type,
        );
        return selectedProduct![idx].title == selectedProductValue
            ? selectedProductValue != null
                ? Text(
                    'Note: Available Quantity is ${getTotalProductQty.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: kCyanColor,
                    ),
                  )
                : Container()
            : Container();
      }
    }).toList();
  }

  Future pickDate(BuildContext context) async {
    final initalDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initalDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return;

    setState(() => date = newDate);
    uploadDate = DateFormat('dd/MM/yyyy').format(date!);
    _editSalesEntry = SalesEntry(
      id: _editSalesEntry.id,
      productName: _editSalesEntry.productName,
      customerName: _editSalesEntry.customerName,
      salesQty: _editSalesEntry.salesQty,
      salesDateTime: uploadDate!,
      salesPrice: _editSalesEntry.salesPrice,
      salesType: _editSalesEntry.salesType,
    );
  }
}
