import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_packaging_v2/models/product.dart';
import 'package:genesis_packaging_v2/models/purchase_entry.dart';
import 'package:genesis_packaging_v2/models/vendor.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/provider/purchase_entry_provider.dart';
import 'package:genesis_packaging_v2/provider/vendor_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/app_drawer.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PurchaseEntryScreen extends StatefulWidget {
  const PurchaseEntryScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseEntryScreen> createState() => _PurchaseEntryScreenState();
}

class _PurchaseEntryScreenState extends State<PurchaseEntryScreen> {
  var _isLoading = false;
  String? selectedProductValue;
  String? selectedVendorValue;
  List<Product>? product;
  List<Product>? selectedProduct;
  List<Vendor>? vendor;
  List<Vendor>? selectedVendor;
  TextEditingController purchaseQtyController = TextEditingController();
  int? getTotalProductQty;
  String? idToUpdateQty;
  final FocusScopeNode _node = FocusScopeNode();
  final _form = GlobalKey<FormState>();
  var _editpurchaseEntry = PurchaseEntry(
    id: null,
    productName: '',
    vendorName: '',
    purchaseQty: 0,
    purchaseDateTime: '',
    purchasePrice: 0.0,
    purchaseType: '',
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
    final vendorData = Provider.of<VendorProvider>(context, listen: false);
    super.initState();
    product = productData.items.toList();
    vendor = vendorData.items.toList();
    selectedProduct = product;
    selectedVendor = vendor;
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
    await Provider.of<PurchaseEntryProvider>(context, listen: false)
        .addPurchaseEntry(_editpurchaseEntry);

    await Provider.of<ProductProvider>(context, listen: false)
        .updateProduct(idToUpdateQty!, _updateProductQty)
        .then(
          (_) => SnackBarWidget.showSnackBar(
            context,
            'PurchaseEntry saved',
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
        title: const Text('Purchase Entry', style: kAppbarTextStyle),
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
                              const Text('Vendor Name'),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: buildVendorNameDropdown()),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .pushNamed('/EditVendorScreen'),
                                      icon: SvgPicture.asset(
                                        'assets/icons/plus.svg',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: purchaseQtyController,
                                decoration: const InputDecoration(
                                  labelText: 'Purchase Qty',
                                  labelStyle: TextStyle(fontSize: 12),
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editpurchaseEntry = PurchaseEntry(
                                    id: _editpurchaseEntry.id,
                                    productName: selectedProductValue,
                                    vendorName: selectedVendorValue,
                                    purchaseQty: int.parse(value!),
                                    purchaseDateTime:
                                        _editpurchaseEntry.purchaseDateTime,
                                    purchasePrice:
                                        _editpurchaseEntry.purchasePrice,
                                    purchaseType:
                                        _editpurchaseEntry.purchaseType,
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
                              const Text('Purchase Date'),
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
                                  labelText: 'Purchase Price',
                                  labelStyle: TextStyle(fontSize: 12),
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editpurchaseEntry = PurchaseEntry(
                                    id: _editpurchaseEntry.id,
                                    productName: selectedProductValue,
                                    vendorName: selectedVendorValue,
                                    purchaseQty: _editpurchaseEntry.purchaseQty,
                                    purchaseDateTime:
                                        _editpurchaseEntry.purchaseDateTime,
                                    purchasePrice: double.parse(value!),
                                    purchaseType:
                                        _editpurchaseEntry.purchaseType,
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
                                  labelText: 'Purchase Type (cash/cheque...)',
                                  labelStyle: TextStyle(fontSize: 12),
                                ),
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editpurchaseEntry = PurchaseEntry(
                                    id: _editpurchaseEntry.id,
                                    productName: selectedProductValue,
                                    vendorName: selectedVendorValue,
                                    purchaseQty: _editpurchaseEntry.purchaseQty,
                                    purchaseDateTime:
                                        _editpurchaseEntry.purchaseDateTime,
                                    purchasePrice:
                                        _editpurchaseEntry.purchasePrice,
                                    purchaseType: value!,
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
              hint: const Text('Select Vendor'),
              items: vendor!.map((item) {
                return DropdownMenuItem(
                  child: Text(item.name!),
                  value: item.name,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedVendorValue = newValue as String?;
                });
              },
              value: selectedVendorValue,
            ),
          ),
        ),
      );

  _quantityField() {
    return selectedProduct!.asMap().entries.map((product) {
      int idx = product.key;
      idToUpdateQty = selectedProduct![idx].id;
      if (purchaseQtyController.text.isEmpty) {
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
        getTotalProductQty = (selectedProduct![idx].quantity! +
            int.parse(purchaseQtyController.text));
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
    _editpurchaseEntry = PurchaseEntry(
      id: _editpurchaseEntry.id,
      productName: _editpurchaseEntry.productName,
      vendorName: _editpurchaseEntry.vendorName,
      purchaseQty: _editpurchaseEntry.purchaseQty,
      purchaseDateTime: uploadDate!,
      purchasePrice: _editpurchaseEntry.purchasePrice,
      purchaseType: _editpurchaseEntry.purchaseType,
    );
  }
}
