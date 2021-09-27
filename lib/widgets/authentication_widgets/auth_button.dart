import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';

class AuthenticationButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onClicked;

  const AuthenticationButton({
    Key? key,
    required this.text,
    this.onClicked,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        primary: kPrimaryColor,
        onPrimary: Colors.white,
        shape: const StadiumBorder(),
      ),
      onPressed: () {},
      child: Text(
        text!,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
