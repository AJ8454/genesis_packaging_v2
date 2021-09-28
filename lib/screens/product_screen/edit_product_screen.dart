import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/models/product.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _isInit = true;
  var _isLoading = false;
  final FocusScopeNode _node = FocusScopeNode();
  final _form = GlobalKey<FormState>();

  var _editProduct = Product(
    id: null,
    size: 0.0,
    title: '',
    type: '',
    color: '',
    dateTime: '',
    quantity: 0,
    gstNo: '',
    // imageUrl: '',
    rate: 0.0,
    supplier: '',
  );

  var _initValues = {
    'size': '',
    'title': '',
    'type': '',
    'color': '',
    'dateTime': '',
    'quantity': '',
    'gstNo': '',
    // 'imageUrl': '',
    'rate': '',
    'supplier': '',
  };

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
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId.toString());
        _initValues = {
          'size': _editProduct.size.toString(),
          'title': _editProduct.title!,
          'type': _editProduct.type!,
          'color': _editProduct.color.toString(),
          'dateTime': _editProduct.dateTime.toString(),
          'quantity': _editProduct.quantity.toString(),
          'gstNo': _editProduct.gstNo.toString(),
          // 'imageUrl': '',
          'rate': _editProduct.rate.toString(),
          'supplier': _editProduct.supplier.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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

    if (_editProduct.id != null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editProduct.id!, _editProduct)
          .then(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Product Updated.',
                  style: TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.orange[400],
              ),
            ),
          );
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(_editProduct)
            .then(
              (_) => SnackBarWidget.showSnackBar(
                context,
                'Product Saved',
              ),
            );
      } catch (e) {}
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: kAppbarTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: const Icon(FontAwesomeIcons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            FocusScope(
                              node: _node,
                              child: Form(
                                key: _form,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      initialValue: _initValues['title'],
                                      decoration: const InputDecoration(
                                          labelText: 'Title'),
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: _node.nextFocus,
                                      onSaved: (value) {
                                        _editProduct = Product(
                                          title: value!,
                                          id: _editProduct.id,
                                          color: _editProduct.color,
                                          dateTime: _editProduct.dateTime,
                                          gstNo: _editProduct.gstNo,
                                          //imageUrl: _editProduct.imageUrl,
                                          quantity: _editProduct.quantity,
                                          rate: _editProduct.rate,
                                          size: _editProduct.size,
                                          supplier: _editProduct.supplier,
                                          type: _editProduct.type,
                                        );
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a title.';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: _initValues['size'],
                                      decoration: const InputDecoration(
                                          labelText: 'Size'),
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: _node.nextFocus,
                                      keyboardType: TextInputType.number,
                                      onSaved: (value) {
                                        _editProduct = Product(
                                          title: _editProduct.title,
                                          id: _editProduct.id,
                                          color: _editProduct.color,
                                          dateTime: _editProduct.dateTime,
                                          gstNo: _editProduct.gstNo,
                                          //imageUrl: _editProduct.imageUrl,
                                          quantity: _editProduct.quantity,
                                          rate: _editProduct.rate,
                                          size: double.parse(value!),
                                          supplier: _editProduct.supplier,
                                          type: _editProduct.type,
                                        );
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter the size.';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Please enter a valid size.';
                                        }

                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: _initValues['type'],
                                      decoration: const InputDecoration(
                                          labelText: 'Type'),
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: _node.nextFocus,
                                      onSaved: (value) {
                                        _editProduct = Product(
                                          title: _editProduct.title,
                                          id: _editProduct.id,
                                          color: _editProduct.color,
                                          dateTime: _editProduct.dateTime,
                                          gstNo: _editProduct.gstNo,
                                          //imageUrl: _editProduct.imageUrl,
                                          quantity: _editProduct.quantity,
                                          rate: _editProduct.rate,
                                          size: _editProduct.size,
                                          supplier: _editProduct.supplier,
                                          type: value!,
                                        );
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a type.';
                                        }

                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: _initValues['quantity'],
                                      decoration: const InputDecoration(
                                          labelText: 'Quantity'),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      onEditingComplete: _node.nextFocus,
                                      onSaved: (value) {
                                        _editProduct = Product(
                                          title: _editProduct.title,
                                          id: _editProduct.id,
                                          color: _editProduct.color,
                                          dateTime: _editProduct.dateTime,
                                          gstNo: _editProduct.gstNo,
                                          //imageUrl: _editProduct.imageUrl,
                                          quantity: int.parse(value!),
                                          rate: _editProduct.rate,
                                          size: _editProduct.size,
                                          supplier: _editProduct.supplier,
                                          type: _editProduct.type,
                                        );
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a quantity.';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: _initValues['color'],
                                      decoration: const InputDecoration(
                                          labelText: 'Color'),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      onEditingComplete: _node.nextFocus,
                                      onSaved: (value) {
                                        _editProduct = Product(
                                          title: _editProduct.title,
                                          id: _editProduct.id,
                                          color: value!,
                                          dateTime: _editProduct.dateTime,
                                          gstNo: _editProduct.gstNo,
                                          //imageUrl: _editProduct.imageUrl,
                                          quantity: _editProduct.quantity,
                                          rate: _editProduct.rate,
                                          size: _editProduct.size,
                                          supplier: _editProduct.supplier,
                                          type: _editProduct.type,
                                        );
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a color.';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: _initValues['supplier'],
                                      decoration: const InputDecoration(
                                          labelText: 'Supplier'),
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: _node.nextFocus,
                                      onSaved: (value) {
                                        _editProduct = Product(
                                          title: _editProduct.title,
                                          id: _editProduct.id,
                                          color: _editProduct.color,
                                          dateTime: _editProduct.dateTime,
                                          gstNo: _editProduct.gstNo,
                                          //imageUrl: _editProduct.imageUrl,
                                          quantity: _editProduct.quantity,
                                          rate: _editProduct.rate,
                                          size: _editProduct.size,
                                          supplier: value!,
                                          type: _editProduct.type,
                                        );
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a supplier.';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 32),
                                    Row(
                                      children: [
                                        const Text(
                                          'Date :',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(width: 32),
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
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      initialValue: _initValues['rate'],
                                      decoration: const InputDecoration(
                                          labelText: 'Rate'),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      onEditingComplete: _node.nextFocus,
                                      onSaved: (value) {
                                        _editProduct = Product(
                                          title: _editProduct.title,
                                          id: _editProduct.id,
                                          color: _editProduct.color,
                                          dateTime: _editProduct.dateTime,
                                          gstNo: _editProduct.gstNo,
                                          //imageUrl: _editProduct.imageUrl,
                                          quantity: _editProduct.quantity,
                                          rate: double.parse(value!),
                                          size: _editProduct.size,
                                          supplier: _editProduct.supplier,
                                          type: _editProduct.type,
                                        );
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a rate.';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: _initValues['gstNo'],
                                      decoration: const InputDecoration(
                                          labelText: 'GST No'),
                                      onSaved: (value) {
                                        _editProduct = Product(
                                          title: _editProduct.title,
                                          id: _editProduct.id,
                                          color: _editProduct.color,
                                          dateTime: _editProduct.dateTime,
                                          gstNo: value!,
                                          //imageUrl: _editProduct.imageUrl,
                                          quantity: _editProduct.quantity,
                                          rate: _editProduct.rate,
                                          size: _editProduct.size,
                                          supplier: _editProduct.supplier,
                                          type: _editProduct.type,
                                        );
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a GST no.';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 25),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 40),
                                        primary: kCyanColor,
                                        elevation: 8,
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () => _submitForm(),
                                      child: const Text(
                                        'save',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
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
                ],
              ),
            ),
    );
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
    _editProduct = Product(
      title: _editProduct.title,
      rate: _editProduct.rate,
      size: _editProduct.size,
      color: _editProduct.color,
      gstNo: _editProduct.gstNo,
      quantity: _editProduct.quantity,
      supplier: _editProduct.supplier,
      type: _editProduct.type,
      dateTime: uploadDate!,
      id: _editProduct.id,
    );
  }
}
