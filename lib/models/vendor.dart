import 'package:flutter/material.dart';

class Vendor with ChangeNotifier {
  final String? id;
  final String? name;
  final String? companyName;
  final String? vendorAddress;
  final int? vendorMobileNum;
  final String? vendorEmail;

  Vendor({
    required this.id,
    required this.name,
    required this.companyName,
    required this.vendorAddress,
    required this.vendorMobileNum,
    required this.vendorEmail,
  });

}
