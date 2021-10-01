import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/models/vendor.dart';
import 'package:http/http.dart' as http;

class VendorProvider with ChangeNotifier {
// setter
  List<Vendor> _items = [];

// getter
  List<Vendor> get items {
    return [..._items];
  }

  Vendor findById(String? id) {
    return _items.firstWhere((prod) => prod.id! == id!);
  }

  Future<void> fetchAndSetVendor() async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/vendor.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Vendor> loadedVendor = [];
      extractedData.forEach((prodId, prodData) {
        loadedVendor.add(Vendor(
          id: prodId,
          name: prodData['name'],
          companyName: prodData['companyName'],
          vendorAddress: prodData['address'],
          vendorMobileNum: prodData['vendorMobileNo'],
          vendorEmail: prodData['vendorEmail'],
        ));
      });
      _items = loadedVendor;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addVendor(Vendor vendor) async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/vendor.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'name': vendor.name,
          'companyName': vendor.companyName,
          'address': vendor.vendorAddress,
          'vendorMobileNo': vendor.vendorMobileNum,
          'vendorEmail': vendor.vendorEmail,
        }),
      );
      final newVendor = Vendor(
        id: json.decode(response.body)['name'],
        name: vendor.name,
        companyName: vendor.companyName,
        vendorAddress: vendor.vendorAddress,
        vendorMobileNum: vendor.vendorMobileNum,
        vendorEmail: vendor.vendorEmail,
      );
      _items.add(newVendor);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateVendor(String id, Vendor newVendor) async {
    final vendorIndex = _items.indexWhere((prod) => prod.id == id);
    if (vendorIndex >= 0) {
      final url =
          'https://genesispackaging-9905b-default-rtdb.firebaseio.com/vendor/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'name': newVendor.name,
            'companyName': newVendor.companyName,
            'address': newVendor.vendorAddress,
            'vendorMobileNo': newVendor.vendorMobileNum,
            'vendorEmail': newVendor.vendorEmail,
          }));
      _items[vendorIndex] = newVendor;
      notifyListeners();
    }
  }

  Future<void> deleteVendor(String? id) async {
    final url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/vendor/$id.json';
    final exsistingVendorIndex = _items.indexWhere((prod) => prod.id == id);
    dynamic exsistingVendor = _items[exsistingVendorIndex];
    _items.removeAt(exsistingVendorIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(exsistingVendorIndex, exsistingVendor);
      notifyListeners();
    }
    exsistingVendor = null;
  }
}
