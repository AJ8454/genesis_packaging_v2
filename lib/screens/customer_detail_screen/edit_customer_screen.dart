import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/models/customer.dart';
import 'package:genesis_packaging_v2/provider/customer_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class EditCustomerScreen extends StatefulWidget {
  const EditCustomerScreen({Key? key}) : super(key: key);

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  var _isInit = true;
  var _isLoading = false;
  final FocusScopeNode _node = FocusScopeNode();
  final _form = GlobalKey<FormState>();
  var _editCustomer = Customer(
    id: null,
    name: '',
    companyName: '',
    customerAddress: '',
    customerEmail: '',
    customerMobileNum: 0,
  );

  var _initValues = {
    'name': '',
    'companyName': '',
    'customerAddress': '',
    'customerEamil': '',
    'customerMobileNum': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final customerId = ModalRoute.of(context)!.settings.arguments;
      if (customerId != null) {
        _editCustomer = Provider.of<CustomerProvider>(context, listen: false)
            .findById(customerId.toString());
        _initValues = {
          'name': _editCustomer.name!,
          'companyName': _editCustomer.companyName!,
          'customerAddress': _editCustomer.customerAddress!,
          'customerEamil': _editCustomer.customerEmail!,
          'customerMobileNum': _editCustomer.customerMobileNum.toString(),
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

    if (_editCustomer.id != null) {
      await Provider.of<CustomerProvider>(context, listen: false)
          .updateCustomer(_editCustomer.id!, _editCustomer)
          .then(
            (_) => SnackBarWidget.showSnackBar(
              context,
              'Customer updated',
            ),
          );
    } else {
      await Provider.of<CustomerProvider>(context, listen: false)
          .addCustomer(_editCustomer)
          .then(
            (_) => SnackBarWidget.showSnackBar(
              context,
              'Customer saved',
            ),
          );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Add/Update',
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
          : ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      FocusScope(
                        node: _node,
                        child: Form(
                          key: _form,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: _initValues['name'],
                                decoration: const InputDecoration(
                                    labelText: 'Customer Name'),
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editCustomer = Customer(
                                    name: value!,
                                    id: _editCustomer.id,
                                    companyName: _editCustomer.companyName,
                                    customerAddress:
                                        _editCustomer.customerAddress,
                                    customerEmail: _editCustomer.customerEmail,
                                    customerMobileNum:
                                        _editCustomer.customerMobileNum,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a customer name.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                initialValue: _initValues['companyName'],
                                decoration: const InputDecoration(
                                    labelText: 'Customer Company Name'),
                                textInputAction: TextInputAction.next,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editCustomer = Customer(
                                    name: _editCustomer.name,
                                    id: _editCustomer.id,
                                    companyName: value!,
                                    customerAddress:
                                        _editCustomer.customerAddress,
                                    customerEmail: _editCustomer.customerEmail,
                                    customerMobileNum:
                                        _editCustomer.customerMobileNum,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the company name.';
                                  }

                                  return null;
                                },
                              ),
                              TextFormField(
                                initialValue: _initValues['customerAddress'],
                                decoration: const InputDecoration(
                                    labelText: 'Customer Address'),
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editCustomer = Customer(
                                    name: _editCustomer.name,
                                    id: _editCustomer.id,
                                    companyName: _editCustomer.companyName,
                                    customerAddress: value!,
                                    customerEmail: _editCustomer.customerEmail,
                                    customerMobileNum:
                                        _editCustomer.customerMobileNum,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the address.';
                                  }

                                  return null;
                                },
                              ),
                              TextFormField(
                                initialValue: _initValues['customerMobileNum'],
                                decoration: const InputDecoration(
                                    labelText: 'Customer Mobile No'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                onEditingComplete: _node.nextFocus,
                                onSaved: (value) {
                                  _editCustomer = Customer(
                                    name: _editCustomer.name,
                                    id: _editCustomer.id,
                                    companyName: _editCustomer.companyName,
                                    customerAddress:
                                        _editCustomer.customerAddress,
                                    customerEmail: _editCustomer.customerEmail,
                                    customerMobileNum: int.parse(value!),
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter mobile number.';
                                  } else if (value.length < 10) {
                                    return 'Please enter correct mobile number.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                initialValue: _initValues['customerEamil'],
                                decoration: const InputDecoration(
                                    labelText: 'Customer Eamil'),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (value) {
                                  _editCustomer = Customer(
                                    name: _editCustomer.name,
                                    id: _editCustomer.id,
                                    companyName: _editCustomer.companyName,
                                    customerAddress:
                                        _editCustomer.customerAddress,
                                    customerEmail: value!,
                                    customerMobileNum:
                                        _editCustomer.customerMobileNum,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a email id.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 40),
                                  primary: kCyanColor,
                                  elevation: 8,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () => _submitForm(),
                                child: const Text(
                                  'Save',
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
    );
  }
}
