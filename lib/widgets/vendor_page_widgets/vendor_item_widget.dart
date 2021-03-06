import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_packaging_v2/provider/vendor_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:provider/provider.dart';

import '../snack_bar.dart';

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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                _vendorInfo(Icons.person, widget.name!),
                _vendorInfo(Icons.location_city, widget.companyName!),
                _vendorInfo(Icons.location_on, widget.address!),
                _vendorInfo(Icons.phone, widget.vendorMobileNo!),
                _vendorInfo(Icons.local_post_office, widget.vendorEmail!),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: SvgPicture.asset('assets/icons/editIcon.svg'),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/EditVendorScreen', arguments: widget.id);
                  },
                  color: Colors.brown,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 25,
                  ),
                  onPressed: () async {
                    try {
                      await Provider.of<VendorProvider>(context, listen: false)
                          .deleteVendor(widget.id!);

                      Navigator.of(context).popUntil((route) => route.isFirst);
                      SnackBarWidget.showSnackBar(
                        context,
                        'Vendor Deleted',
                      );
                    } catch (error) {
                      SnackBarWidget.showSnackBar(
                        context,
                        'Deleting Failed',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vendorInfo(
    IconData? icon,
    String? text,
  ) {
    return Row(
      children: [
        Icon(
          icon!,
          color: kGreyColor,
          size: 16,
        ),
        const SizedBox(width: 10),
        Text(
          text!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: kAppbarTextStyle,
        ),
      ],
    );
  }
}
