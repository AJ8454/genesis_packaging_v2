import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/models/order.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  // setter
  List<OrderTodo> _items = [];

// getter
  List<OrderTodo> get items =>
      _items.where((todo) => todo.isDone == false).toList();

// getter
  List<OrderTodo> get todosCompleted =>
      _items.where((todo) => todo.isDone == true).toList();

  Future<void> fetchAndSetNewPlaceOrder(String? dbFile) async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/$dbFile.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderTodo> loadedPlaceNewOrder = [];
      extractedData.forEach((newOrderId, newOrderData) {
        loadedPlaceNewOrder.add(OrderTodo(
          id: newOrderId,
          title: newOrderData['title'],
          balanceQty: newOrderData['balQty'],
          createdTime: newOrderData['createdTime'],
          newOrder: newOrderData['newOrder'],
          supplier: newOrderData['supplier'],
          isDone: newOrderData['isDone'],
        ));
      });
      _items = loadedPlaceNewOrder;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addPlaceOrder(
      OrderTodo newPlaceOrder, String? dbFile, bool? isDone) async {
    var url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/$dbFile.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': newPlaceOrder.title,
          'balQty': newPlaceOrder.balanceQty,
          'supplier': newPlaceOrder.supplier,
          'createdTime': newPlaceOrder.createdTime,
          'newOrder': newPlaceOrder.newOrder,
          'isDone': isDone,
        }),
      );
      final placeOrder = OrderTodo(
        id: json.decode(response.body)['name'],
        title: newPlaceOrder.title,
        balanceQty: newPlaceOrder.balanceQty,
        newOrder: newPlaceOrder.newOrder,
        createdTime: newPlaceOrder.createdTime,
        isDone: isDone,
      );
      _items.add(placeOrder);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deletePlacenewOreder(String id, String? dbFile) async {
    final url =
        'https://genesispackaging-9905b-default-rtdb.firebaseio.com/$dbFile/$id.json';
    final exsistingProductIndex = _items.indexWhere((prod) => prod.id == id);
    dynamic exsistingProduct = _items[exsistingProductIndex];
    _items.removeAt(exsistingProductIndex);
    notifyListeners();
    // _items.removeWhere((prod) => prod.id == id);
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(exsistingProductIndex, exsistingProduct);
      notifyListeners();
    }
    exsistingProduct = null;
  }
}
