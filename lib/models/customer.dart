import 'package:flutter/material.dart';

class Customer with ChangeNotifier {
  final String? id;
  final String? name;
  final String? companyName;
  final String? customerAddress;
  final int? customerMobileNum;
  final String? customerEmail;

  Customer({
    required this.id,
    required this.name,
    required this.companyName,
    required this.customerAddress,
    required this.customerMobileNum,
    required this.customerEmail,
  });
}
