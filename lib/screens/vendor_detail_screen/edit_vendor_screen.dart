import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/models/vendor.dart';
import 'package:genesis_packaging_v2/provider/vendor_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class EditVendorScreen extends StatefulWidget {
  const EditVendorScreen({Key? key}) : super(key: key);

  @override
  _EditVendorScreenState createState() => _EditVendorScreenState();
}

class _EditVendorScreenState extends State<EditVendorScreen> {
  var _isInit = true;
  var _isLoading = false;
  final FocusScopeNode _node = FocusScopeNode();
  final _form = GlobalKey<FormState>();
  var _editVendor = Vendor(
    id: null,
    name: '',
    companyName: '',
    vendorAddress: '',
    vendorEmail: '',
    vendorMobileNum: 0,
  );

  var _initValues = {
    'name': '',
    'companyName': '',
    'vendorAddress': '',
    'vendorEamil': '',
    'vendorMobileNum': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final vendorId = ModalRoute.of(context)!.settings.arguments;
      if (vendorId != null) {
        _editVendor = Provider.of<VendorProvider>(context, listen: false)
            .findById(vendorId.toString());
        _initValues = {
          'name': _editVendor.name!,
          'companyName': _editVendor.companyName!,
          'vendorAddress': _editVendor.vendorAddress!,
          'vendorEamil': _editVendor.vendorEmail!,
          'vendorMobileNum': _editVendor.vendorMobileNum.toString(),
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

    if (_editVendor.id != null) {
      await Provider.of<VendorProvider>(context, listen: false)
          .updateVendor(_editVendor.id!, _editVendor)
          .then(
            (_) => SnackBarWidget.showSnackBar(
              context,
              'Vendor updated',
            ),
          );
    } else {
      await Provider.of<VendorProvider>(context, listen: false)
          .addVendor(_editVendor)
          .then(
            (_) => SnackBarWidget.showSnackBar(
              context,
              'Vendor saved',
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
          'Vendor Add/Update',
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
              padding: const EdgeInsets.all(12.0),
              child: Expanded(
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
                                  initialValue: _initValues['name'],
                                  decoration: const InputDecoration(
                                      labelText: 'Vendor Name'),
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: _node.nextFocus,
                                  onSaved: (value) {
                                    _editVendor = Vendor(
                                      name: value!,
                                      id: _editVendor.id,
                                      companyName: _editVendor.companyName,
                                      vendorAddress: _editVendor.vendorAddress,
                                      vendorEmail: _editVendor.vendorEmail,
                                      vendorMobileNum:
                                          _editVendor.vendorMobileNum,
                                    );
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a vendor name.';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  initialValue: _initValues['companyName'],
                                  decoration: const InputDecoration(
                                      labelText: 'Vendor Company Name'),
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: _node.nextFocus,
                                  onSaved: (value) {
                                    _editVendor = Vendor(
                                      name: _editVendor.name,
                                      id: _editVendor.id,
                                      companyName: value!,
                                      vendorAddress: _editVendor.vendorAddress,
                                      vendorEmail: _editVendor.vendorEmail,
                                      vendorMobileNum:
                                          _editVendor.vendorMobileNum,
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
                                  initialValue: _initValues['vendorAddress'],
                                  decoration: const InputDecoration(
                                      labelText: 'Vendor Address'),
                                  textInputAction: TextInputAction.next,
                                  maxLines: 3,
                                  onEditingComplete: _node.nextFocus,
                                  onSaved: (value) {
                                    _editVendor = Vendor(
                                      name: _editVendor.name,
                                      id: _editVendor.id,
                                      companyName: _editVendor.companyName,
                                      vendorAddress: value!,
                                      vendorEmail: _editVendor.vendorEmail,
                                      vendorMobileNum:
                                          _editVendor.vendorMobileNum,
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
                                  initialValue: _initValues['vendorMobileNum'],
                                  decoration: const InputDecoration(
                                      labelText: 'Vendor Mobile No'),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  onEditingComplete: _node.nextFocus,
                                  onSaved: (value) {
                                    _editVendor = Vendor(
                                      name: _editVendor.name,
                                      id: _editVendor.id,
                                      companyName: _editVendor.companyName,
                                      vendorAddress: _editVendor.vendorAddress,
                                      vendorEmail: _editVendor.vendorEmail,
                                      vendorMobileNum: int.parse(value!),
                                    );
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter mobile number.';
                                    } else if (value.length <= 10) {
                                      return 'Please enter correct mobile number.';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  initialValue: _initValues['vendorEamil'],
                                  decoration: const InputDecoration(
                                      labelText: 'Vendor Eamil'),
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (value) {
                                    _editVendor = Vendor(
                                      name: _editVendor.name,
                                      id: _editVendor.id,
                                      companyName: _editVendor.companyName,
                                      vendorAddress: _editVendor.vendorAddress,
                                      vendorEmail: value!,
                                      vendorMobileNum:
                                          _editVendor.vendorMobileNum,
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
                                    minimumSize:
                                        const Size(double.infinity, 40),
                                    primary: kCyanColor,
                                    elevation: 8,
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () => _submitForm(),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[800],
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
            ),
    );
  }
}
