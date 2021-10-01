import 'package:flutter/material.dart';

class PurchaseEntry with ChangeNotifier {
  final String? id;
  final String? productName;
  final String? vendorName;
  final int? purchaseQty;
  final String? purchaseDateTime;
  final double? purchasePrice;
  final String? purchaseType;
  
  PurchaseEntry({
    required this.id,
    required this.productName,
    required this.vendorName,
    required this.purchaseQty,
    required this.purchaseDateTime,
    required this.purchasePrice,
    required this.purchaseType,
  });
}
