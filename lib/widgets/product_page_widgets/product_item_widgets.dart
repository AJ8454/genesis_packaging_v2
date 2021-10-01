import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:provider/provider.dart';
import '../snack_bar.dart';

class ProductItem extends StatefulWidget {
  final String? id;
  final String? title;
  final String? imageUrl;
  final String? balQty;
  const ProductItem({
    Key? key,
    this.id,
    this.title,
    this.imageUrl,
    this.balQty,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 90,
              child: widget.imageUrl!.contains('firebasestorage')
                  ? Image.network(
                      widget.imageUrl!,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/landscape-image.svg',
                      ),
                    ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  height: 50,
                  color: kCyanColor.withOpacity(0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      SizedBox(
                        width: 100,
                        child: Text(
                          widget.title!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        'BalQty : ${widget.balQty!}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  color: const Color(0xFFDA4453).withOpacity(0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      IconButton(
                        icon: SvgPicture.asset('assets/icons/editIcon.svg'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/EditProductScreen',
                              arguments: widget.id);
                        },
                        color: Colors.brown,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 25,
                        ),
                        onPressed: () async {
                          try {
                            await Provider.of<ProductProvider>(context,
                                    listen: false)
                                .deleteProduct(widget.id!);
                            Reference ref = FirebaseStorage.instance
                                .refFromURL(widget.imageUrl!);
                            await ref.delete();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            SnackBarWidget.showSnackBar(
                              context,
                              'Product Deleted',
                            );
                          } catch (error) {
                            SnackBarWidget.showSnackBar(
                              context,
                              'Deleting Failed',
                            );
                          }
                        },
                        color: Colors.black,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
