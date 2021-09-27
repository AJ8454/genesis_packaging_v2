import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';

class GridItems extends StatelessWidget {
  final String? iconPath;
  final String? title;
  final VoidCallback? onClicked;

  const GridItems({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.onClicked,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan[800],
      highlightColor: Colors.grey.withOpacity(0.5),
      onTap: onClicked,
      child: Card(
        elevation: 5,
        color: kCyanColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath!,
              height: 50,
            ),
            const SizedBox(height: 10),
            Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
