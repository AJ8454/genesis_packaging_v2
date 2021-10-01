import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/models/purchase_entry.dart';
import 'package:http/http.dart' as http;

class PurchaseEntryProvider with ChangeNotifier {
// setter
  List<PurchaseEntry> _items = [];

// getter
  List<PurchaseEntry> get items {
    return [..._items];
  }

  PurchaseEntry findById(String? id) {
    return _items.firstWhere((prod) => prod.id! == id!);
  }

  Future<void> fetchAndSetPurchaseEntry() async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/purchaseEntry.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<PurchaseEntry> loadedPurchaseEntry = [];
      extractedData.forEach((prodId, prodData) {
        loadedPurchaseEntry.add(PurchaseEntry(
          id: prodId,
          productName: prodData['productName'],
          vendorName: prodData['vendorName'],
          purchaseQty: prodData['purchaseQty'],
          purchaseDateTime: prodData['purchaseDate'],
          purchasePrice: prodData['purchasePrice'],
          purchaseType: prodData['purchaseType'],
        ));
      });
      _items = loadedPurchaseEntry;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addPurchaseEntry(PurchaseEntry purchaseEntry) async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/purchaseEntry.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'productName': purchaseEntry.productName,
          'vendorName': purchaseEntry.vendorName,
          'purchaseQty': purchaseEntry.purchaseQty,
          'purchaseDate': purchaseEntry.purchaseDateTime,
          'purchasePrice': purchaseEntry.purchasePrice,
          'purchaseType': purchaseEntry.purchaseType,
        }),
      );
      final newPurchaseEntry = PurchaseEntry(
        id: json.decode(response.body)['name'],
        productName: purchaseEntry.productName,
        vendorName: purchaseEntry.vendorName,
        purchaseQty: purchaseEntry.purchaseQty,
        purchaseDateTime: purchaseEntry.purchaseDateTime,
        purchasePrice: purchaseEntry.purchasePrice,
        purchaseType: purchaseEntry.purchaseType,
      );
      _items.add(newPurchaseEntry);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updatePurchaseEntry(
      String id, PurchaseEntry newPurchaseEntry) async {
    final purchaseEntry = _items.indexWhere((prod) => prod.id == id);
    if (purchaseEntry >= 0) {
      final url =
          'https://genesispackaging-9905b-default-rtdb.firebaseio.com/purchaseEntry/$id.json';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'productName': newPurchaseEntry.productName,
            'vendorName': newPurchaseEntry.vendorName,
            'purchaseQty': newPurchaseEntry.purchaseQty,
            'purchaseDate': newPurchaseEntry.purchaseDateTime,
            'purchasePrice': newPurchaseEntry.purchasePrice,
            'purchaseType': newPurchaseEntry.purchaseType,
          }));
      _items[purchaseEntry] = newPurchaseEntry;
      notifyListeners();
    }
  }

  Future<void> deletePurchaseEntry(String? id) async {
    final url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/purchaseEntry/$id.json';
    final exsistingPurchaseEntryIndex =
        _items.indexWhere((prod) => prod.id == id);
    dynamic exsistingPurchaseEntry = _items[exsistingPurchaseEntryIndex];
    _items.removeAt(exsistingPurchaseEntry);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(exsistingPurchaseEntryIndex, exsistingPurchaseEntry);
      notifyListeners();
    }
    exsistingPurchaseEntry = null;
  }
}
