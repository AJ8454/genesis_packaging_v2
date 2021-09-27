import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:genesis_packaging_v2/provider/google_sign_in_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(FontAwesomeIcons.google),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        onPrimary: kCanvasColor,
        shape: const StadiumBorder(),
      ),
      onPressed: () {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.login();
        //UserSimplePreferences.setUser(false);
      },
      label: const Text(
        'Google',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
