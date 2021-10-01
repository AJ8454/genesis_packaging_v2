import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_packaging_v2/provider/customer_provider.dart';
import 'package:genesis_packaging_v2/provider/vendor_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:provider/provider.dart';

import '../snack_bar.dart';

class CustomerItem extends StatefulWidget {
  final String? id;
  final String? name;
  final String? companyName;
  final String? address;
  final String? customerMobileNo;
  final String? customerEmail;
  const CustomerItem({
    Key? key,
    this.id,
    this.name,
    this.companyName,
    this.address,
    this.customerMobileNo,
    this.customerEmail,
  }) : super(key: key);
  @override
  _CustomerItemState createState() => _CustomerItemState();
}

class _CustomerItemState extends State<CustomerItem> {
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
                _customerInfo(Icons.person, widget.name!),
                _customerInfo(Icons.location_city, widget.companyName!),
                _customerInfo(Icons.location_on, widget.address!),
                _customerInfo(Icons.phone, widget.customerMobileNo!),
                _customerInfo(Icons.local_post_office, widget.customerEmail!),
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
                        .pushNamed('/EditCustomerScreen', arguments: widget.id);
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
                      await Provider.of<CustomerProvider>(context, listen: false)
                          .deleteCustomer(widget.id!);

                      Navigator.of(context).popUntil((route) => route.isFirst);
                      SnackBarWidget.showSnackBar(
                        context,
                        'Customer Deleted',
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

  Widget _customerInfo(
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
