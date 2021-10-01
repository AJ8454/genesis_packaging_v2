import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/models/customer.dart';
import 'package:http/http.dart' as http;

class CustomerProvider with ChangeNotifier {
// setter
  List<Customer> _items = [];

// getter
  List<Customer> get items {
    return [..._items];
  }

  Customer findById(String? id) {
    return _items.firstWhere((prod) => prod.id! == id!);
  }

  Future<void> fetchAndSetCustomer() async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/customer.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Customer> loadedCustomer = [];
      extractedData.forEach((prodId, prodData) {
        loadedCustomer.add(Customer(
          id: prodId,
          name: prodData['name'],
          companyName: prodData['companyName'],
          customerAddress: prodData['address'],
          customerMobileNum: prodData['customerMobileNo'],
          customerEmail: prodData['customerEmail'],
        ));
      });
      _items = loadedCustomer;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addCustomer(Customer customer) async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/customer.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'name': customer.name,
          'companyName': customer.companyName,
          'address': customer.customerAddress,
          'vendorMobileNo': customer.customerMobileNum,
          'vendorEmail': customer.customerEmail,
        }),
      );
      final newCustomer = Customer(
        id: json.decode(response.body)['name'],
        name: customer.name,
        companyName: customer.companyName,
        customerAddress: customer.customerAddress,
        customerMobileNum: customer.customerMobileNum,
        customerEmail: customer.customerEmail,
      );
      _items.add(newCustomer);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateCustomer(String id, Customer newCustomer) async {
    final customerIndex = _items.indexWhere((prod) => prod.id == id);
    if (customerIndex >= 0) {
      final url =
          'https://genesispackaging-9905b-default-rtdb.firebaseio.com/customer/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'name': newCustomer.name,
            'companyName': newCustomer.companyName,
            'address': newCustomer.customerAddress,
            'vendorMobileNo': newCustomer.customerMobileNum,
            'vendorEmail': newCustomer.customerEmail,
          }));
      _items[customerIndex] = newCustomer;
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String? id) async {
    final url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/customer/$id.json';
    final exsistingCustomerIndex = _items.indexWhere((prod) => prod.id == id);
    dynamic exsistingCustomer = _items[exsistingCustomerIndex];
    _items.removeAt(exsistingCustomerIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(exsistingCustomerIndex, exsistingCustomer);
      notifyListeners();
    }
    exsistingCustomer = null;
  }
}
