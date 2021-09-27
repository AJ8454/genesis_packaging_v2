import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:provider/provider.dart';
import '../snack_bar.dart';

class ProductItem extends StatefulWidget {
  final String? id;
  final String? title;
  final String? imageUrl;
  final String? type;
  const ProductItem({
    Key? key,
    this.id,
    this.title,
    this.imageUrl,
    this.type,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  widget.imageUrl!,
                  width: 40,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: kDarkColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.type!,
                  style: const TextStyle(
                    fontSize: 9,
                    color: kGreyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.edit,
                size: 22.0,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/stockEditScreen', arguments: widget.id);
              },
              color: Colors.brown,
            ),
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.trash,
                size: 22.0,
              ),
              onPressed: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false)
                      .deleteProduct(widget.id!)
                      .then(
                        (_) => SnackBarWidget.showSnackBar(
                          context,
                          'Product Deleted',
                        ),
                      );
                } catch (error) {
                  SnackBarWidget.showSnackBar(
                    context,
                    'Deleting Failed',
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
