import 'package:flutter/material.dart';

class SalesEntry with ChangeNotifier {
  final String? id;
  final String? productName;
  final String? customerName;
  final int? salesQty;
  final String? salesDateTime;
  final double? salesPrice;
  final String? salesType;

  SalesEntry({
    required this.id,
    required this.productName,
    required this.customerName,
    required this.salesQty,
    required this.salesDateTime,
    required this.salesPrice,
    required this.salesType,
  });
}
