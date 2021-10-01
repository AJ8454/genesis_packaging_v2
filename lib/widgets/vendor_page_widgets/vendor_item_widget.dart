import 'package:flutter/material.dart';

class VendorItem extends StatefulWidget {
  final String? id;
  final String? name;
  final String? companyName;
  final String? address;
  final String? vendorMobileNo;
  final String? vendorEmail;
  const VendorItem({
    Key? key,
    this.id,
    this.name,
    this.companyName,
    this.address,
    this.vendorMobileNo,
    this.vendorEmail,
  }) : super(key: key);
  @override
  _VendorItemState createState() => _VendorItemState();
}

class _VendorItemState extends State<VendorItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(children: [
        Text(widget.name!),
        Text(widget.companyName!),
        Text(widget.address!),
        Text(widget.vendorMobileNo!),
        Text(widget.vendorEmail!),
      ]),
    );
  }
}
