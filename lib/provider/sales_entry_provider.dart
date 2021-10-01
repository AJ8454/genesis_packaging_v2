import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/models/sales_entry.dart';
import 'package:http/http.dart' as http;

class SalesEntryProvider with ChangeNotifier {
// setter
  List<SalesEntry> _items = [];

// getter
  List<SalesEntry> get items {
    return [..._items];
  }

  SalesEntry findById(String? id) {
    return _items.firstWhere((prod) => prod.id! == id!);
  }

  Future<void> fetchAndSetSalesEntry() async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/salesEntry.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<SalesEntry> loadedSalesEntry = [];
      extractedData.forEach((prodId, prodData) {
        loadedSalesEntry.add(SalesEntry(
          id: prodId,
          productName: prodData['productName'],
          customerName: prodData['customerName'],
          salesQty: prodData['salesQty'],
          salesDateTime: prodData['salesDate'],
          salesPrice: prodData['salesPrice'],
          salesType: prodData['salesType'],
        ));
      });
      _items = loadedSalesEntry;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addsSalesEntry(SalesEntry salesEntry) async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/salesEntry.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'productName': salesEntry.productName,
          'customerName': salesEntry.customerName,
          'salesQty': salesEntry.salesQty,
          'salesDate': salesEntry.salesDateTime,
          'salesPrice': salesEntry.salesPrice,
          'salesType': salesEntry.salesType,
        }),
      );
      final newSalesEntry = SalesEntry(
        id: json.decode(response.body)['name'],
        productName: salesEntry.productName,
        customerName: salesEntry.customerName,
        salesQty: salesEntry.salesQty,
        salesDateTime: salesEntry.salesDateTime,
        salesPrice: salesEntry.salesPrice,
        salesType: salesEntry.salesType,
      );
      _items.add(newSalesEntry);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateSalesEntry(String id, SalesEntry newSalesEntry) async {
    final salesEntry = _items.indexWhere((prod) => prod.id == id);
    if (salesEntry >= 0) {
      final url =
          'https://genesispackaging-9905b-default-rtdb.firebaseio.com/salesEntry/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'productName': newSalesEntry.productName,
            'customerName': newSalesEntry.customerName,
            'salesQty': newSalesEntry.salesQty,
            'salesDate': newSalesEntry.salesDateTime,
            'salesPrice': newSalesEntry.salesPrice,
            'salesType': newSalesEntry.salesType,
          }));
      _items[salesEntry] = newSalesEntry;
      notifyListeners();
    }
  }

  Future<void> deleteSalesEntry(String? id) async {
    final url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/salesEntry/$id.json';
    final exsistingSalesEntryIndex = _items.indexWhere((prod) => prod.id == id);
    dynamic exsistingSalesEntry = _items[exsistingSalesEntryIndex];
    _items.removeAt(exsistingSalesEntry);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(exsistingSalesEntryIndex, exsistingSalesEntry);
      notifyListeners();
    }
    exsistingSalesEntry = null;
  }
}
