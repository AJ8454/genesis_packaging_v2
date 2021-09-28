import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/provider/product_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:provider/provider.dart';
import '../snack_bar.dart';

class ProductItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        imageUrl!,
        height: 20,
      ),
      title: Text(
        title!,
        style: const TextStyle(
          fontSize: 15,
          color: kCyanColor,
          fontWeight: FontWeight.w900,
        ),
      ),
      subtitle: Text(
        type!,
        style: const TextStyle(
          fontSize: 9,
          color: kGreyColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              size: 22.0,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/stockEditScreen', arguments: id);
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
                    .deleteProduct(id!);
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
    );
  }

  
}
